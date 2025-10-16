#!/usr/bin/env bash
set -euo pipefail

# ------------------------
# CONFIG
# ------------------------
NUM_CORES=$(nproc)
ASEPRITE_DIR="$HOME/aseprite"
SKIA_DIR="$HOME/deps/skia"
BUILD_DIR="$ASEPRITE_DIR/build"

# ------------------------
# Helpers
# ------------------------
info() { echo -e "\e[1;34m[INFO]\e[0m $*"; }
warn() { echo -e "\e[1;33m[WARN]\e[0m $*"; }
error() { echo -e "\e[1;31m[ERROR]\e[0m $*"; exit 1; }

# ------------------------
# Ensure depot_tools is present
# ------------------------
if [ ! -d "$HOME/depot_tools" ]; then
    info "Cloning depot_tools..."
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git "$HOME/depot_tools"
fi

export PATH="$HOME/depot_tools:$PATH"

# ------------------------
# Ensure Skia repo is present
# ------------------------
if [ ! -d "$SKIA_DIR" ]; then
    info "Cloning Skia repository..."
    git clone https://skia.googlesource.com/skia.git "$SKIA_DIR"
fi

cd "$SKIA_DIR"

# Optional: sync submodules
info "Updating Skia repository..."
git fetch --all
git checkout main
git pull

# ------------------------
# GN + Ninja build for Skia
# ------------------------
info "Generating Skia build files with GN..."
gn gen out/Release-x64 --args="
is_official_build=true
is_debug=false
skia_enable_tools=false
skia_use_gl=true
skia_use_vulkan=false
skia_use_system_expat=false
skia_use_system_icu=false
skia_use_system_libjpeg_turbo=false
skia_use_system_libpng=false
skia_use_system_libwebp=false
skia_use_system_zlib=false
skia_use_system_freetype2=false
skia_use_system_harfbuzz=false
extra_cflags=[\"-O2\"]
target_cpu=\"x86\"
"

info "Building Skia with Ninja..."
ninja -C out/Release-x64

# ------------------------
# Build Aseprite
# ------------------------
info "Configuring Aseprite build..."
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

cmake -G "Unix Makefiles" \
  -DLAF_BACKEND=skia \
  -DSKIA_DIR="$SKIA_DIR" \
  -DSKIA_LIBRARY="$SKIA_DIR/out/Release-x64/libskia.a" \
  -DSKIA_LIBRARY_DIR="$SKIA_DIR/out/Release-x64" \
  ..

info "Building Aseprite..."
make -j"$NUM_CORES"

info "Aseprite built successfully! Binary is in $BUILD_DIR"
