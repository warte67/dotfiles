#!/bin/bash
set -e
set -o pipefail

# -----------------------------
# Configurable paths
# -----------------------------
ASEPRITE_DIR="$HOME/aseprite"
SKIA_DIR="$HOME/deps/skia"
PYTHON_VERSION="3.12.12"

# -----------------------------
# Step 0: Install system dependencies
# -----------------------------
echo "Installing Debian build dependencies..."
sudo apt update
sudo apt install -y git build-essential cmake ninja-build curl unzip \
    python3-pip pkg-config zlib1g-dev libfreetype6-dev libpng-dev \
    libwebp-dev libjpeg-turbo8-dev libx11-dev libxext-dev libgl1-mesa-dev \
    libglu1-mesa-dev libxrandr-dev libxi-dev libxcursor-dev libxinerama-dev

# -----------------------------
# Step 1: Install pyenv and Python 3.12
# -----------------------------
echo "Installing pyenv..."
if [ ! -d "$HOME/.pyenv" ]; then
    curl https://pyenv.run | bash
fi

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

echo "Installing Python $PYTHON_VERSION via pyenv..."
pyenv install -s $PYTHON_VERSION
pyenv global $PYTHON_VERSION
python --version

# -----------------------------
# Step 2: Clone Skia
# -----------------------------
echo "Cloning Skia..."
mkdir -p "$SKIA_DIR"
cd "$SKIA_DIR"
if [ ! -d ".git" ]; then
    git clone https://skia.googlesource.com/skia.git .
fi

# Sync dependencies
echo "Syncing Skia dependencies..."
python tools/git-sync-deps

# -----------------------------
# Step 3: Build Skia with GPU
# -----------------------------
echo "Generating Skia build files..."
rm -rf out/Release-x64
bin/gn gen out/Release-x64 --args="
is_official_build=true
is_debug=false
skia_enable_tools=false
skia_use_gl=true
skia_enable_gpu=true
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

echo "Building Skia..."
ninja -C out/Release-x64 -v

# -----------------------------
# Step 4: Clone Aseprite
# -----------------------------
echo "Cloning Aseprite..."
mkdir -p "$ASEPRITE_DIR"
cd "$ASEPRITE_DIR"
if [ ! -d ".git" ]; then
    git clone --branch v15.2.1 --recursive https://github.com/aseprite/aseprite.git .
fi

# -----------------------------
# Step 5: Configure and build Aseprite
# -----------------------------
echo "Building Aseprite..."
BUILD_DIR="$ASEPRITE_DIR/build"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

cmake -G "Unix Makefiles" \
    -DLAF_BACKEND=skia \
    -DSKIA_DIR="$SKIA_DIR" \
    -DSKIA_LIBRARY_DIR="$SKIA_DIR/out/Release-x64" \
    -DSKIA_LIBRARY="$SKIA_DIR/out/Release-x64/libskia.a" \
    ..

make -j$(nproc)

echo "✅ Aseprite build completed!"
echo "You can run it via: $BUILD_DIR/bin/aseprite"
