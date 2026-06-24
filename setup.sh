#!/usr/bin/env bash

set -euo pipefail

echo "=================================="
echo "Provisioning Fedora DevBox"
echo "=================================="

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
echo "Installing Development and DevOps tools..."
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
echo "Installing yq..."
sudo wget -O /usr/local/bin/yq \
https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
sudo chmod +x /usr/local/bin/yq

echo
echo "Installing SDKMAN..."
curl -s "https://get.sdkman.io" | bash
set +u
source "$HOME/.sdkman/bin/sdkman-init.sh"

echo
echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
echo

echo "Installing Java, Maven and Gradle via SDKMAN..."
sdk install java --default -y
sdk install maven --default -y
sdk install gradle --default -y
set -u

echo
echo "Installed versions"
echo

git --version
java -version
mvn -version
node --version
npm --version
python3 --version
go version
rustc --version
cargo --version
php --version
composer --version
terraform version
kubectl version --client
helm version
ansible --version

echo
echo "=================================="
echo "Provisioning completed!"
echo "=================================="
