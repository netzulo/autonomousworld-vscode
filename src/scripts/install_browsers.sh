#!/usr/bin/env bash
set -euo pipefail

echo "Installing browser runtime (opt-in)"

: "${BROWSERS_ENABLED:=false}"

if [[ "${BROWSERS_ENABLED}" != "true" ]]; then
  echo "BROWSERS_ENABLED is not true; skipping browser install."
  exit 0
fi

apt-get update

# Install Google Chrome from the official APT repository to avoid snap-based Chromium packages
apt-get install -y --no-install-recommends wget gnupg ca-certificates

install -m 0755 -d /etc/apt/keyrings
wget -qO- https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list

apt-get update
apt-get install -y --no-install-recommends google-chrome-stable

apt-get clean && rm -rf /var/lib/apt/lists/*

if command -v google-chrome >/dev/null 2>&1; then
  echo "Google Chrome installed: $(google-chrome --version || true)"
elif command -v chromium-browser >/dev/null 2>&1; then
  echo "Chromium installed: $(chromium-browser --version || true)"
elif command -v chromium >/dev/null 2>&1; then
  echo "Chromium installed: $(chromium --version || true)"
else
  echo "Browser install completed, but no supported browser binary found on PATH." >&2
fi
