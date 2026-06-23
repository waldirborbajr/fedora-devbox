#!/usr/bin/env bash

set -euo pipefail

echo "=================================="
echo "Provisionando Fedora DevBox"
echo "=================================="

echo
echo "Atualizando repositórios..."
sudo dnf update -y


echo
echo "Instalando plugins DNF..."
sudo dnf install -y dnf-plugins-core

echo
echo "Adicionando repositório HashiCorp..."
sudo wget -O /etc/yum.repos.d/hashicorp.repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo

echo
echo "Instalando ferramentas de Desenvolvimento e DevOps..."

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
    python3 \
    python3-pip \
    golang \
    nodejs \
    npm \
    podman \
    ansible \
    terraform \
    kubectl \
    helm \
    awscli \
    redis \
    php \
    composer


echo
echo "Instalando yq..."

sudo wget -O /usr/local/bin/yq \
https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64

sudo chmod +x /usr/local/bin/yq


echo
echo "Instalando SDKMAN..."
curl -s "https://get.sdkman.io" | bash

set +u
source "$HOME/.sdkman/bin/sdkman-init.sh"

echo
echo "Instalando Java, Maven e Gradle via SDKMAN..."
sdk install java
sdk install maven
sdk install gradle
set -u


echo
echo "Versões instaladas"

echo
git --version

java --version

mvn --version

node --version

npm --version

python3 --version

go version

php --version

composer --version

terraform version

kubectl version --client

helm version

ansible --version


echo
echo "=================================="
echo "Provisionamento concluído!"
echo "=================================="
