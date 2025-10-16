#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# CONFIGURATION
# -----------------------------
ASEPRITE_DIR="$HOME/aseprite"
SKIA_DIR="$HOME/deps/skia"
SKIA_OUT="$SKIA_DIR/out/Release-x64"

PYTHON_VERSION="3.12.12"

NUM_CORES=$(nproc)

# -----------------------------
# HELPER FUNCTIONS
# -----------------------------
function install_pyenv_and_python() {
    if ! command -v pyenv &>/dev/null; then
        echo "Installing pyenv..."
        curl https://pyenv.run | bash
        export PATH="$HOME/.pyenv/bin:$PATH"
        eval "$(pyenv init --path)"
        eval "$(pyenv init -)"
        eval "$(pyenv virtualenv-init -)"
    fi

    if ! pyenv versions | grep -q "$PYTHON_VERSION"; then
        echo "Installing Python $PYTHON_VERSION via pyenv..."
        pyenv install -s "$PYTHON_VERSION"
    fi

    pyenv global "$PYTHON_VERSION"
    echo "Using Python: $(python --version)"
}

function build_skia() {
    echo "Cleaning previous Skia build..."
    rm -rf "$SKIA_OUT"

    echo "Generating Skia build files..."
    cd "$SKIA_DIR"
    python3 tools/git-sync-deps

    bin/gn gen "$SKIA_OUT" --args="
is_official_build=true
is_debug=false
skia_enable_tools=false
skia_use_gl=true
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
    ninja -C "$SKIA_OUT" -v
}

function build_aseprite() {
    echo "Configuring Aseprite..."
    cd "$ASEPRITE_DIR/build"

    cmake -G "Unix Makefiles" \
        -DLAF_BACKEND=skia \
        -DSKIA_DIR="$SKIA_DIR" \
        -DSKIA_LIBRARY_DIR="$SKIA_OUT" \
        -DSKIA_LIBRARY="$SKIA_OUT/libskia.a" \
        ..

    echo "Building Aseprite..."
    make -j"$NUM_CORES"
}

# -----------------------------
# MAIN SCRIPT
# -----------------------------
echo "=== Starting Aseprite build script ==="
install_pyenv_and_python
build_skia
build_aseprite
echo "=== Aseprite build finished successfully! ==="
