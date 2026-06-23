#!/usr/bin/env bash

set -e

echo "=================================="
echo "Provisionando Fedora DevBox"
echo "=================================="

echo
echo "Atualizando repositórios..."
sudo dnf update -y


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
    java-21-openjdk-devel \
    maven \
    gradle \
    podman \
    ansible \
    terraform \
    kubectl \
    helm \
    awscli2 \
    postgresql \
    mysql \
    redis


echo
echo "Instalando yq..."

sudo wget -O /usr/local/bin/yq \
https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64

sudo chmod +x /usr/local/bin/yq


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

terraform version

kubectl version --client

helm version

ansible --version


echo
echo "=================================="
echo "Provisionamento concluído!"
echo "=================================="
