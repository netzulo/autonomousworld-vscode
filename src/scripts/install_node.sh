#!/bin/bash
set -e

echo "🟢 Installing Node.js using NVM..."

# Use fallback version if not provided
NODE_VERSION=${NODE_VERSION:-20.11.1}
NVM_VERSION="0.39.7"

# Install NVM
export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_VERSION/install.sh | bash

# Load NVM into current shell
source "$NVM_DIR/nvm.sh"

# Install and use the desired Node.js version
nvm install "$NODE_VERSION"
nvm use "$NODE_VERSION"
nvm alias default "$NODE_VERSION"

# Make it available globally in container sessions
echo "export NVM_DIR=\"$HOME/.nvm\"" >> ~/.bashrc
echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\"" >> ~/.bashrc

# Verify installation
echo "Node version: $(node -v)"
echo "NPM version: $(npm -v)"
echo "NVM version: $(nvm --version)"