#!/bin/bash
set -euo pipefail

echo "Starting autonomous dev environment..."

if [[ "${INSTALL_VSCODE:-true}" == "true" ]]; then
  export PASSWORD="${VSCODE_PASSWORD:-agent}"

  # Start code-server or shell
  echo "Launching VS Code (code-server) on :${VSCODE_PORT:-8443}"
  exec code-server --bind-addr "0.0.0.0:${VSCODE_PORT:-8443}" --auth password /workspace
else
  echo "Starting bash..."
  exec bash
fi