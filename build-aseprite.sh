#!/usr/bin/env bash
set -euo pipefail

# ---------------------------
# Variables
# ---------------------------
ASEPRITE_DIR="$HOME/aseprite"
SKIA_DIR="$HOME/deps/skia"
PYTHON_VERSION="3.12.12"
NUM_CORES=$(nproc)

# ---------------------------
# 1. Install pyenv and Python 3.12
# ---------------------------
if ! command -v pyenv >/dev/null 2>&1; then
    echo "Installing pyenv..."
    curl https://pyenv.run | bash
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# Ensure Python 3.12 is installed
if ! pyenv versions | grep -q "$PYTHON_VERSION"; then
    echo "Installing Python $PYTHON_VERSION..."
    pyenv install -s "$PYTHON_VERSION"
fi

pyenv global "$PYTHON_VERSION"
echo "Using Python: $(python --version)"

# ---------------------------
# 2. Build Skia
# ---------------------------
mkdir -p "$SKIA_DIR"
cd "$SKIA_DIR"

# Fetch Skia dependencies and GN if missing
if [ ! -f "$SKIA_DIR/bin/gn" ]; then
    echo "Fetching Skia dependencies..."
    python tools/git-sync-deps
fi

echo "Generating Skia build files..."
"$SKIA_DIR/bin/gn" gen out/Release-x64 --args="
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

echo "Building Skia..."
ninja -C out/Release-x64

# ---------------------------
# 3. Build Aseprite
# ---------------------------
mkdir -p "$ASEPRITE_DIR/build"
cd "$ASEPRITE_DIR/build"

cmake -G "Unix Makefiles" \
  -DLAF_BACKEND=skia \
  -DSKIA_DIR="$SKIA_DIR" \
  -DSKIA_LIBRARY_DIR="$SKIA_DIR/out/Release-x64" \
  -DSKIA_LIBRARY="$SKIA_DIR/out/Release-x64/libskia.a" \
  ..

echo "Building Aseprite..."
make -j"$NUM_CORES"

echo "Build finished! Aseprite binary is in $ASEPRITE_DIR/build/bin/"
