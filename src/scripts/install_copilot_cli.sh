#!/usr/bin/env bash
set -euo pipefail

echo "Installing GitHub Copilot CLI (opt-in)"

: "${COPILOT_CLI_ENABLED:=false}"
: "${COPILOT_CLI_INSTALL_METHOD:=auto}"
: "${COPILOT_CLI_INSTALL_URL:=https://gh.io/copilot-install}"
: "${COPILOT_CLI_PREFIX:=/usr/local}"
: "${COPILOT_CLI_VERSION:=}"
: "${COPILOT_CLI_MCP_SEED:=false}"
: "${COPILOT_CLI_MCP_CONFIG_TEMPLATE:=/opt/copilot/mcp-config.json}"
: "${COPILOT_CLI_MCP_CONFIG_PATH:=/root/.copilot/mcp-config.json}"

if [[ "${COPILOT_CLI_ENABLED}" != "true" ]]; then
  echo "COPILOT_CLI_ENABLED is not true; skipping Copilot CLI installation."
  exit 0
fi

install_via_script() {
  echo "Installing Copilot CLI via official install script..."
  if [[ -n "${COPILOT_CLI_VERSION}" ]]; then
    curl -fsSL "${COPILOT_CLI_INSTALL_URL}" | VERSION="${COPILOT_CLI_VERSION}" PREFIX="${COPILOT_CLI_PREFIX}" bash
  else
    curl -fsSL "${COPILOT_CLI_INSTALL_URL}" | PREFIX="${COPILOT_CLI_PREFIX}" bash
  fi
}

install_via_npm() {
  echo "Installing Copilot CLI via npm..."
  if ! command -v npm >/dev/null 2>&1; then
    echo "npm not found; cannot install Copilot CLI via npm." >&2
    return 1
  fi
  if [[ -n "${COPILOT_CLI_VERSION}" ]]; then
    npm install -g "@github/copilot@${COPILOT_CLI_VERSION}"
  else
    npm install -g @github/copilot
  fi
}

if [[ "${COPILOT_CLI_INSTALL_METHOD}" == "script" ]]; then
  install_via_script
elif [[ "${COPILOT_CLI_INSTALL_METHOD}" == "npm" ]]; then
  install_via_npm
else
  install_via_script || install_via_npm
fi

if command -v copilot >/dev/null 2>&1; then
  echo "Copilot CLI installed: $(copilot --version)"
else
  echo "Copilot CLI installation finished, but 'copilot' is not on PATH." >&2
fi

if [[ "${COPILOT_CLI_MCP_SEED}" == "true" ]]; then
  if [[ -f "${COPILOT_CLI_MCP_CONFIG_TEMPLATE}" ]]; then
    echo "Seeding Copilot CLI MCP config..."
    mkdir -p "$(dirname "${COPILOT_CLI_MCP_CONFIG_PATH}")"
    cp "${COPILOT_CLI_MCP_CONFIG_TEMPLATE}" "${COPILOT_CLI_MCP_CONFIG_PATH}"
  else
    echo "MCP config template not found at ${COPILOT_CLI_MCP_CONFIG_TEMPLATE}; skipping seed." >&2
  fi
else
  echo "COPILOT_CLI_MCP_SEED is not true; skipping MCP config seed."
fi
