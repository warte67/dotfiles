#!/usr/bin/env bash
set -e
set -o pipefail

# -------------------------------
# CONFIGURATION
# -------------------------------
ASEPRITE_DIR="$HOME/aseprite"
SKIA_DIR="$HOME/deps/skia"
PYTHON_VERSION="3.12.12"
BUILD_DIR="$ASEPRITE_DIR/build"
NUM_CORES=$(nproc)

# -------------------------------
# FUNCTIONS
# -------------------------------
info() { echo -e "\e[1;34m[INFO]\e[0m $*"; }
warn() { echo -e "\e[1;33m[WARN]\e[0m $*"; }
error() { echo -e "\e[1;31m[ERROR]\e[0m $*"; exit 1; }

# -------------------------------
# Install pyenv & Python
# -------------------------------
info "Installing pyenv and Python $PYTHON_VERSION..."

if [ -d "$HOME/.pyenv" ]; then
    warn "Existing pyenv detected. Removing..."
    rm -rf "$HOME/.pyenv"
fi

curl https://pyenv.run | bash

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv install -s "$PYTHON_VERSION"
pyenv global "$PYTHON_VERSION"

info "Python version: $(python --version)"

# -------------------------------
# Build Skia
# -------------------------------
info "Building Skia..."

mkdir -p "$SKIA_DIR/out/Release-x64"
cd "$SKIA_DIR"

if [ ! -f "bin/gn" ]; then
    info "Bootstrapping GN..."
    python tools/git-sync-deps
fi

bin/gn gen out/Release-x64 --args="
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
"

info "Compiling Skia..."
ninja -C out/Release-x64

if [ ! -f "$SKIA_DIR/out/Release-x64/include/gpu/GrDirectContext.h" ]; then
    error "Skia build failed: GPU headers missing."
fi

info "Skia built successfully!"

# -------------------------------
# Build Aseprite
# -------------------------------
info "Building Aseprite..."

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

cmake -G "Unix Makefiles" \
  -DLAF_BACKEND=skia \
  -DSKIA_DIR="$SKIA_DIR" \
  -DSKIA_LIBRARY_DIR="$SKIA_DIR/out/Release-x64" \
  -DSKIA_LIBRARY="$SKIA_DIR/out/Release-x64/libskia.a" \
  ..

info "Compiling Aseprite..."
make -j"$NUM_CORES"

info "Aseprite built successfully! Binary is in $BUILD_DIR"
