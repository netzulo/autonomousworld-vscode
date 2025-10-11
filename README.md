# 🛠️ Autonomous Dev Environment

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

---

## 📄 Roadmap

- [ ] Create base docker image for "autonomous-dev" environment
- [ ] LLM Chatgpt or copilot working inside the container

---

> ✍️ *Last updated:* 2025-10-11
