# --------------------------------------------------
# Autonomous Dev Environment Dockerfile
# Base image: Ubuntu 22.04
# --------------------------------------------------

FROM ubuntu:22.04

LABEL maintainer="autonomousworld"
LABEL name="ephemereal-node"

SHELL ["/bin/bash", "-c"]

# --------------------------------------------
# ENV Defaults (override with Docker Compose or CLI)
# --------------------------------------------
ENV LANGUAGES=node,python,java,go \
    NODE_VERSION=20.11.1 \
    ASDF_VERSION=v0.14.0 \
    PYTHON_VERSION=3.12.1 \
    JAVA_VERSION=temurin-17.0.10+7 \
    GO_VERSION=1.22.6 \
    VSCODE_DIR=/opt/vscode \
    VSCODE_PORT=8443 \
    VSCODE_PASSWORD=agent \
    OPENAI_API_KEY=your_openai_api_key_here \
    OPENAI_MODEL=gpt-4 \
    GITLAB_PERSONAL_ACCESS_TOKEN=your_gitlab_token_here \
    GITHUB_MCP_VERSION=v0.18.0 \
    GITHUB_PERSONAL_ACCESS_TOKEN=your_github_token_here \
    GITHUB_TOOLSETS=repos,issues,pull_requests,actions,code_security

# --------------------------------------------
# Locale setup
# --------------------------------------------
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y locales && \
    locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# --------------------------------------------
# Base system setup
# --------------------------------------------
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    zip \
    gnupg \
    ca-certificates \
    sudo \
    software-properties-common \
    python3-pip \
    python3-venv \
    bash-completion \
    $CUSTOM_PACKAGES && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# --------------------------------------------
# Terminal Editors (optional)
# --------------------------------------------
RUN echo "Installing terminal editors..." && \
    apt-get update && apt-get install -y micro vim nano

# --------------------------------------------
# Copy scripts
# --------------------------------------------
COPY src/scripts /opt/scripts/
RUN chmod +x /opt/scripts/*.sh || true

# --------------------------------------------
# Install languages
# --------------------------------------------
RUN for lang in $(echo $LANGUAGES | tr "," "\n"); do \
    bash /opt/scripts/install_${lang}.sh || echo "No script for $lang"; \
done
# Source bashrc to load asdf and installed languages
RUN . ~/.bashrc

# --------------------------------------------
# VS Code + extensions + MCPs + settings
# --------------------------------------------
COPY src/vscode "${VSCODE_DIR}/"
COPY src/vscode/settings.json /root/.local/share/code-server/User/settings.json
COPY src/vscode/extensions /root/.local/share/code-server/extensions/
COPY src/vscode/mcp.json /root/.local/share/code-server/User/mcp.json

RUN bash /opt/scripts/install_vscode.sh

# --------------------------------------------
# Workspace and shell + IDE config
# --------------------------------------------
RUN mkdir -p /workspace
WORKDIR /workspace

# Copy workspace config files
COPY src/workspace/. /workspace/

# Expose VS Code port
EXPOSE ${VSCODE_PORT}

# Start code-server on container start
COPY src/scripts/entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh
CMD ["/opt/entrypoint.sh"]