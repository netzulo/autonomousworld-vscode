echo "🔧 Installing Foxit PDF Action Inspector (MCP) into asdf Python..."
set +u
[ -f /root/.bashrc ] && source /root/.bashrc
set -u
if [ -f /opt/asdf/asdf.sh ]; then
  export ASDF_DIR=/opt/asdf
  export ASDF_DATA_DIR=/opt/asdf
  . /opt/asdf/asdf.sh
  export PATH="/opt/asdf/bin:/opt/asdf/shims:$PATH"
fi

# Use python from asdf (or fallback to python3 if not available)
PY_BIN="$(command -v python || command -v python3 || true)"
if [ -z "${PY_BIN}" ]; then
  echo "No Python interpreter found to install mcp-server-git"; exit 1
fi

"${PY_BIN}" -m pip install --no-cache-dir --upgrade pip
"${PY_BIN}" -m pip install --no-cache-dir pdf-action-inspector

# Sanity check
# "${PY_BIN}" - <<'PY'
# import sys
# print("Python:", sys.executable)
# import pdf-action-inspector as m
# print("pdf-action-inspector OK from", m.__file__)
# PY