#!/usr/bin/env bash

set -euo pipefail

echo "=================================="
echo "Provisioning Fedora DevBox"
echo "=================================="

DEVBOX_CONFIG_DIR="$HOME/.config/devbox"
DEVBOX_MANIFEST="$DEVBOX_CONFIG_DIR/selections.env"

# ============================================================================
# Helpers
# ============================================================================

# ask <pergunta> -> 0 (sim) ou 1 (não)
# Se a entrada padrão não for um terminal interativo (ex: CI, pipe, --yes),
# assume "sim" automaticamente pra todas as perguntas, sem travar o script.
ask() {
  local prompt="$1"
  if [[ ! -t 0 ]]; then
    echo "${prompt} [não-interativo, assumindo Sim]"
    return 0
  fi
  local reply
  while true; do
    read -r -p "${prompt} [Y/n] " reply
    reply="${reply,,}" # lowercase
    case "$reply" in
      ""|y|yes|s|sim) return 0 ;;
      n|no|nao|não)   return 1 ;;
      *) echo "Responda com y/n." ;;
    esac
  done
}

# ============================================================================
# Escolha de linguagens (interativo)
# ============================================================================

echo
echo "Selecione as linguagens/runtimes que deseja instalar:"
echo

INSTALL_GO=0
INSTALL_RUST=0
INSTALL_NODE=0
INSTALL_JAVA=0
INSTALL_PHP=0

ask "Instalar Go?"                              && INSTALL_GO=1
ask "Instalar Rust?"                            && INSTALL_RUST=1
ask "Instalar Node.js?"                         && INSTALL_NODE=1
ask "Instalar Java (via SDKMAN, com Maven/Gradle)?" && INSTALL_JAVA=1
ask "Instalar PHP (com Composer e Laravel installer)?" && INSTALL_PHP=1

echo
echo "Resumo da seleção:"
echo "  Go:   $([[ $INSTALL_GO   -eq 1 ]] && echo sim || echo não)"
echo "  Rust: $([[ $INSTALL_RUST -eq 1 ]] && echo sim || echo não)"
echo "  Node: $([[ $INSTALL_NODE -eq 1 ]] && echo sim || echo não)"
echo "  Java: $([[ $INSTALL_JAVA -eq 1 ]] && echo sim || echo não)"
echo "  PHP:  $([[ $INSTALL_PHP  -eq 1 ]] && echo sim || echo não)"
echo

# Grava o que foi escolhido NESTA execução, para que exports.sh (ou qualquer
# outro script) saiba exatamente o que instalar/exportar, sem precisar
# adivinhar via "o binário existe?" — que ficaria errado se o container for
# reaproveitado de uma execução anterior com escolhas diferentes.
mkdir -p "$DEVBOX_CONFIG_DIR"
cat > "$DEVBOX_MANIFEST" <<EOF
INSTALL_GO=$INSTALL_GO
INSTALL_RUST=$INSTALL_RUST
INSTALL_NODE=$INSTALL_NODE
INSTALL_JAVA=$INSTALL_JAVA
INSTALL_PHP=$INSTALL_PHP
EOF

# ============================================================================
# Repositórios e ferramentas base (sempre instaladas)
# ============================================================================

echo
echo "Updating repositories..."
sudo dnf update -y

echo
echo "Installing DNF plugins..."
sudo dnf install -y dnf-plugins-core

echo
echo "Adding HashiCorp repository..."
sudo wget -O /etc/yum.repos.d/hashicorp.repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo

echo
echo "Installing core CLI and DevOps tools..."
sudo dnf install -y \
    git \
    curl \
    wget \
    jq \
    vim \
    neovim \
    htop \
    tree \
    ripgrep \
    fzf \
    zip \
    unzip \
    tmux \
    make \
    gcc \
    gcc-c++ \
    podman \
    ansible \
    terraform \
    kubectl \
    helm \
    awscli \
    redis

echo
echo "Installing yq..."
sudo wget -O /usr/local/bin/yq \
https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
sudo chmod +x /usr/local/bin/yq

# ============================================================================
# Linguagens (condicionais)
# ============================================================================

if [[ $INSTALL_GO -eq 1 ]]; then
  echo
  echo "Installing Go..."
  sudo dnf install -y golang
fi

if [[ $INSTALL_RUST -eq 1 ]]; then
  echo
  echo "Installing Rust (rustup)..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  # shellcheck disable=SC1090
  source "$HOME/.cargo/env"
fi

if [[ $INSTALL_NODE -eq 1 ]]; then
  echo
  echo "Installing Node.js and npm..."
  sudo dnf install -y nodejs npm
fi

if [[ $INSTALL_JAVA -eq 1 ]]; then
  echo
  echo "Installing SDKMAN..."
  curl -s "https://get.sdkman.io" | bash
  set +u
  # shellcheck disable=SC1090
  source "$HOME/.sdkman/bin/sdkman-init.sh"

  echo "Installing Java, Maven and Gradle via SDKMAN..."
  sdk install java --default -y
  sdk install maven --default -y
  sdk install gradle --default -y
  set -u
fi

if [[ $INSTALL_PHP -eq 1 ]]; then
  echo
  echo "Installing PHP, Composer and Laravel installer..."
  sudo dnf install -y php composer
  composer global require laravel/installer
fi

# ============================================================================
# Versões instaladas
# ============================================================================

echo
echo "Installed versions"
echo

git --version

if [[ $INSTALL_GO -eq 1 ]]; then
  go version
fi

if [[ $INSTALL_RUST -eq 1 ]]; then
  rustc --version
  cargo --version
fi

if [[ $INSTALL_NODE -eq 1 ]]; then
  node --version
  npm --version
fi

if [[ $INSTALL_JAVA -eq 1 ]]; then
  set +u
  # shellcheck disable=SC1090
  source "$HOME/.sdkman/bin/sdkman-init.sh"
  set -u
  java -version
  mvn -version
  gradle --version
fi

if [[ $INSTALL_PHP -eq 1 ]]; then
  php --version
  composer --version
fi

terraform version
kubectl version --client
helm version
ansible --version

echo
echo "=================================="
echo "Provisioning completed!"
echo "=================================="
