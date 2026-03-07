#!/bin/bash
set -euo pipefail

echo "Installing Go using asdf..."

# Fallbacks if not provided by ENV
ASDF_VERSION="${ASDF_VERSION:-v0.14.0}"
GO_VERSION="${GO_VERSION:-1.22.6}"

# Asdf dirs (installation + data in /opt/asdf)
export ASDF_DIR="/opt/asdf"
export ASDF_DATA_DIR="/opt/asdf"
export PATH="$ASDF_DIR/bin:$ASDF_DIR/shims:$PATH"

# Install asdf if not already installed
if [ ! -d "$ASDF_DIR" ]; then
  git clone https://github.com/asdf-vm/asdf.git "$ASDF_DIR" --branch "$ASDF_VERSION"
fi

# Load asdf into the current shell
. "$ASDF_DIR/asdf.sh"

# Plugin golang (idempotent)
if ! asdf plugin list | grep -q '^golang$'; then
  asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
fi

# Install and set as global
asdf install golang "$GO_VERSION"
asdf global golang "$GO_VERSION"
asdf reshim golang "$GO_VERSION"

# Persist in .bashrc (same as your Python script)
echo 'export ASDF_DIR=/opt/asdf'                                      >> ~/.bashrc
echo 'export ASDF_DATA_DIR=/opt/asdf'                                 >> ~/.bashrc
echo 'export PATH="/opt/asdf/bin:/opt/asdf/shims:$PATH"'              >> ~/.bashrc
echo '. /opt/asdf/asdf.sh'                                            >> ~/.bashrc
echo '. /opt/asdf/completions/asdf.bash'                              >> ~/.bashrc

# Verify
echo "Go path: $(command -v go || true)"
echo "Go version: $(go version || true)"
