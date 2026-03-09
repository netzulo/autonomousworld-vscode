# 🛠️ Autonomous Dev Environment

![CI](https://github.com/netzulo/autonomousworld-vscode/actions/workflows/ci.yml/badge.svg)
![Publish](https://github.com/netzulo/autonomousworld-vscode/actions/workflows/docker-publish.yml/badge.svg)
![Release](https://github.com/netzulo/autonomousworld-vscode/actions/workflows/release-please.yml/badge.svg)
![Security](https://github.com/netzulo/autonomousworld-vscode/actions/workflows/security.yml/badge.svg)
![GHCR](https://img.shields.io/badge/ghcr-available-brightgreen)

This repository defines the **autonomous development Docker environment** used by AI agents in the Autonomous World system.  
The goal is to provide a highly configurable, reproducible, and observable dev container that includes:

- Multiple programming languages (via ENV)
- Code editors and terminal tools
- Installed MCPs for AI interaction
- Runtime dependencies for tests, git, browsers, etc.
- A way to scale this across different stacks and agent types

---

## 🚀 Quick Start (WIP)

```bash
# Build the container with default values
docker compose -f docker/docker-compose.dep.yml up --build

# Or override ENV variables dynamically
MCP_ENABLED=true \
LANGUAGES="node,python" \
docker compose -f docker/docker-compose.dep.yml up --build
```

---

## ⚙️ ENV Variables (with defaults)

These variables allow customizing the final image per use case:

```bash
# Languages to install (comma-separated)
LANGUAGES=node,python,java
NODE_VERSION=20.11.1
ASDF_VERSION=v0.14.0
PYTHON_VERSION=3.12.1
JAVA_VERSION=temurin-17.0.10+7

# VS Code (code-server)
VSCODE_PORT=8443
VSCODE_PASSWORD=agent
```


You can create your own `.env` file or copy the template:

```bash
cp env.example .env
```

---
## 🐳 Docker Image

The Dockerfile is located at `Dockerfile` and uses a multi-stage build to optimize the final image size. 

The base image is `ubuntu:24.04`, and it installs:
- Core utilities (`curl`, `git`, `unzip`, etc.)
- ASDF version manager (for managing multiple languages)
- Language runtimes (Node.js, Python, Java) via ASDF
- Code-server (VS Code in-browser)


Docker image can be built with (docker compose recommended):

```bash
# docker compose
docker compose -f docker-compose.yml up --build
```

## ✅ Build Checklist

- [x] ✅ Shell and terminal access
- [ ] ✅ Git installed
- [x] ✅ Core tools (`curl`, `unzip`, `zip`, etc.)
- [x] ✅ Programming languages:
  - [x] Node.js
  - [x] Python
  - [x] Java (optional)
- [x] ✅ Code editor:
  - [x] `vim`, or `vi` (fallback/CLI mode)
  - [x] `code-server` (VS Code in-browser)
    - [x] Extensions installed
    - [x] MCP's accessible
- [ ] ✅ Browsers installed (e.g. headless Chrome)
- [ ] ✅ VNC/Socket access (if enabled)

---

## 🧠 Visual Studio Code (Remote)

By default, the image will install [code-server](https://github.com/coder/code-server) or [openvscode-server](https://github.com/gitpod-io/openvscode-server), allowing remote development directly in the browser.

You can access it via:

```bash
http://localhost:8443
```

Password: defined by `VSCODE_PASSWORD` env variable (default: `agent`)

You can change port/password by overriding:

```env
VSCODE_PORT=8080
VSCODE_PASSWORD=secretpass
```

## 🗂️ Scripts

Language and tool installers live in:

```
src/
├── scripts/
│   ├── entrypoint.sh
│   ├── install_node.sh
│   ├── install_python.sh
│   ├── install_java.sh
│   └── ...
```

Each script should support:
- Headless mode
- Logs to stdout
- ENV overrides

---

## 🤖 Copilot CLI + MCP (opt-in)

This image can optionally install GitHub Copilot CLI and seed a CLI-level MCP config for WebdriverIO MCP.

### Enable during build

Use build args (recommended) to enable the install and seed the MCP config:

```bash
COPILOT_CLI_ENABLED=true \
COPILOT_CLI_MCP_ENABLED=true \
docker compose -f docker-compose.yml up --build
```

Optional build flags:

- `COPILOT_CLI_INSTALL_METHOD` = `auto` | `script` | `npm`
- `COPILOT_CLI_VERSION` = specific version (optional)
- `COPILOT_CLI_PREFIX` = install prefix (default `/usr/local`)
- `BROWSERS_ENABLED=true` to install Google Chrome (`google-chrome-stable`) for MCP browser automation

### MCP seed template

The template lives at [src/copilot/mcp-config.json](src/copilot/mcp-config.json) and is copied to:

```
~/.copilot/mcp-config.json
```

### Authenticate and verify

Inside the container:

```bash
copilot --version
copilot
```

If prompted, run `/login` and follow the instructions. You can also set `GH_TOKEN` or `GITHUB_TOKEN`.

### Minimal demo (headless browser + screenshot)

With MCP seeded and browsers enabled, run a simple flow from Copilot CLI:

1. Start a session
2. Navigate to a URL
3. Take a screenshot
4. Close the session

Example prompt to Copilot CLI:

"Use wdio-mcp to open a headless browser, navigate to https://example.com, take a screenshot at /workspace/example.png, then close the session."

---

---

## 📄 Roadmap

- [ ] Create base docker image for "autonomous-dev" environment
- [ ] LLM Chatgpt or copilot working inside the container

---

> ✍️ *Last updated:* 2025-10-11
