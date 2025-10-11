#!/bin/bash
set -euo pipefail

echo "Installing GitHub MCP server (github-mcp-server)..."

# Server versioning (can be overridden by ENV)
GITHUB_MCP_VERSION="${GITHUB_MCP_VERSION:-v0.18.0}"

# Load asdf if it exists (to have 'go' in PATH)
if [ -f /opt/asdf/asdf.sh ]; then
  export ASDF_DIR=/opt/asdf
  export ASDF_DATA_DIR=/opt/asdf
  . /opt/asdf/asdf.sh
  export PATH="/opt/asdf/bin:/opt/asdf/shims:$PATH"
fi

# Check for Go
if ! command -v go >/dev/null 2>&1; then
  echo "Go is not installed. Run install_go.sh first or add 'go' to LANGUAGES." >&2
  exit 1
fi

# Install binary to /usr/local/bin (do not depend on dynamic GOPATH)
GOBIN=/usr/local/bin go install "github.com/github/github-mcp-server/cmd/github-mcp-server@${GITHUB_MCP_VERSION}"

# Sanity check
if ! command -v github-mcp-server >/dev/null 2>&1; then
  echo "github-mcp-server not found after installation." >&2
  exit 1
fi

github-mcp-server --help >/dev/null 2>&1 || {
  echo "github-mcp-server failed to run." >&2
  exit 1
}

echo "GitHub MCP installed OK at: $(command -v github-mcp-server)"
