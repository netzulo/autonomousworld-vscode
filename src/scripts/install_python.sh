#!/bin/bash
set -euo pipefail

echo "Installing Python using asdf..."

# Fallbacks if not defined as environment variables
ASDF_VERSION="${ASDF_VERSION:-v0.14.0}"
PYTHON_VERSION="${PYTHON_VERSION:-3.12.1}"

# Asdf dirs (installation + data in /opt/asdf)
export ASDF_DIR="/opt/asdf"
export ASDF_DATA_DIR="/opt/asdf"
export PATH="$ASDF_DIR/bin:$ASDF_DIR/shims:$PATH"

# Build dependencies for Python (needed for compilation)
apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
  libffi-dev libncursesw5-dev libgdbm-dev tk-dev liblzma-dev uuid-dev \
  && rm -rf /var/lib/apt/lists/*

# Install asdf if not present
if [ ! -d "$ASDF_DIR" ]; then
  git clone https://github.com/asdf-vm/asdf.git "$ASDF_DIR" --branch "$ASDF_VERSION"
fi

# Load asdf into the current environment
. "$ASDF_DIR/asdf.sh"

# Install Python plugin if not present
if ! asdf plugin list | grep -q '^python$'; then
  asdf plugin add python https://github.com/danhper/asdf-python.git
fi

# Install Python and set it as global version
asdf install python "$PYTHON_VERSION"
asdf global python "$PYTHON_VERSION"
asdf reshim python "$PYTHON_VERSION"

# Add to .bashrc for future sessions
echo 'export ASDF_DIR=/opt/asdf'            >> ~/.bashrc
echo 'export ASDF_DATA_DIR=/opt/asdf'       >> ~/.bashrc
echo 'export PATH="/opt/asdf/bin:/opt/asdf/shims:$PATH"' >> ~/.bashrc
echo '. /opt/asdf/asdf.sh'                  >> ~/.bashrc
echo '. /opt/asdf/completions/asdf.bash'    >> ~/.bashrc

# Verify
echo "Python path: $(command -v python || true)"
echo "Python version: $(python --version || true)"
echo "Pip version: $(pip --version || true)"
