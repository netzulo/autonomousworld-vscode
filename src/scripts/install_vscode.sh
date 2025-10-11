#!/usr/bin/env bash
set -euo pipefail

echo "Installing code-server + configuring + extensions"

: "${VSCODE_DIR:=/opt/vscode}"
: "${VSCODE_PORT:=8443}"
: "${VSCODE_PASSWORD:=agent}"

# 1) Instalar code-server
curl -fsSL https://code-server.dev/install.sh | sh

# 2) Configuración de code-server (user root)
mkdir -p /root/.config/code-server
cat > /root/.config/code-server/config.yaml <<EOF
bind-addr: 0.0.0.0:${VSCODE_PORT}
auth: password
password: ${VSCODE_PASSWORD}
cert: false
EOF

# 3) VS Code User settings (copiar settings.json del repo)
if [ -f "${VSCODE_DIR}/vscode/settings.json" ]; then
  echo "Installing VS Code user settings"
  mkdir -p /root/.local/share/code-server/User
  cp "${VSCODE_DIR}/vscode/settings.json" /root/.local/share/code-server/User/settings.json
else
  echo "${VSCODE_DIR}/vscode/settings.json not found (skipping)"
fi

# 4) Instalar extensiones desde VSIX (si existen)
if compgen -G "${VSCODE_DIR}/extensions/*.vsix" > /dev/null; then
  echo "Installing VSIX extensions from ${VSCODE_DIR}/extensions..."
  for f in ${VSCODE_DIR}/extensions/*.vsix; do
    echo " → Installing $f"
    code-server --install-extension "$f"
  done
else
  echo "No VSIX found under ${VSCODE_DIR}/extensions (skipping)"
fi

# 4.1) Mostrar extensiones instaladas (sanity)
echo "Installed extensions:"
code-server --list-extensions || true

# 5) mcp.json (configuración de MCP en scope User)
if [ -f "${VSCODE_DIR}/vscode/mcp.json" ]; then
  echo "Installing MCP user config"
  mkdir -p /root/.local/share/code-server/User
  cp "${VSCODE_DIR}/vscode/mcp.json" /root/.local/share/code-server/User/mcp.json
else
  echo "${VSCODE_DIR}/vscode/mcp.json not found (skipping)"
fi

# 5.1 Extras for MCP: Git MCP server
./opt/scripts/install_mcp_git.sh
# 5.2 Extras for MCP: PDF Action Inspector
./opt/scripts/install_mcp_pdf_inspector.sh
# 5.3 Extras for MCP: Github MCP server
./opt/scripts/install_mcp_github.sh

echo "code-server setup complete"
