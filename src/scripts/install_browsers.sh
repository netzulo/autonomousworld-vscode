#!/usr/bin/env bash
set -euo pipefail

echo "Installing browser runtime (opt-in)"

: "${BROWSERS_ENABLED:=false}"

if [[ "${BROWSERS_ENABLED}" != "true" ]]; then
  echo "BROWSERS_ENABLED is not true; skipping browser install."
  exit 0
fi

apt-get update

# Try Chromium first; fall back between package names across distros
if ! apt-get install -y --no-install-recommends \
  chromium-browser \
  libnss3 \
  libatk-bridge2.0-0 \
  libgtk-3-0 \
  libx11-xcb1 \
  libxcomposite1 \
  libxdamage1 \
  libxrandr2 \
  libgbm1 \
  libasound2 \
  fonts-liberation; then
  apt-get install -y --no-install-recommends \
    chromium \
    libnss3 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    fonts-liberation
fi

apt-get clean && rm -rf /var/lib/apt/lists/*

if command -v chromium-browser >/dev/null 2>&1; then
  echo "Chromium installed: $(chromium-browser --version || true)"
elif command -v chromium >/dev/null 2>&1; then
  echo "Chromium installed: $(chromium --version || true)"
else
  echo "Browser install completed, but no Chromium binary found on PATH." >&2
fi
