#!/usr/bin/env bash
set -euo pipefail

echo "Installing Java using asdf..."

# Default values
ASDF_VERSION="${ASDF_VERSION:-v0.14.0}"
JAVA_VERSION="${JAVA_VERSION:-temurin-17.0.10+7}"  # zulu-21..., corretto-17..., etc.

# Install asdf dirs (installation + data in /opt/asdf)
export ASDF_DIR="/opt/asdf"
export ASDF_DATA_DIR="/opt/asdf"
export PATH="$ASDF_DIR/bin:$ASDF_DIR/shims:$PATH"

# Minimum Deps for asdf-java (you likely already have most, but just in case)
apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates curl unzip zip gnupg \
  && rm -rf /var/lib/apt/lists/*

# Install asdf if not present
if [ ! -d "$ASDF_DIR" ]; then
  git clone https://github.com/asdf-vm/asdf.git "$ASDF_DIR" --branch "$ASDF_VERSION"
fi

# Load asdf into the current environment
. "$ASDF_DIR/asdf.sh"

# Java plugin (idempotent)
if ! asdf plugin list | grep -q '^java$'; then
  asdf plugin add java https://github.com/halcyon/asdf-java.git
fi

# Install and set as global
asdf install java "$JAVA_VERSION"
asdf global java "$JAVA_VERSION"
asdf reshim java "$JAVA_VERSION"

# Persist for future sessions (same as Python)
{
  echo 'export ASDF_DIR=/opt/asdf'
  echo 'export ASDF_DATA_DIR=/opt/asdf'
  echo 'export PATH="/opt/asdf/bin:/opt/asdf/shims:$PATH"'
  echo '. /opt/asdf/asdf.sh'
  echo '. /opt/asdf/completions/asdf.bash'
} >> ~/.bashrc

# Verification
echo "java path: $(command -v java || true)"
echo "java -version:"
java -version || true