#!/usr/bin/env bash

install_core_tools() {
    export DEBIAN_FRONTEND=noninteractive
    sudo apt-get update
    local packages=(
        git curl wget jq vim neovim htop tree ripgrep fzf zip unzip tmux make build-essential
        podman ansible terraform kubectl helm awscli redis-tools gh bat fd-find
    )
    sudo apt-get install -y "${packages[@]}"
    # No Ubuntu, o pacote é frequentemente 'k9s' ou via snap
    sudo apt-get install -y k9s || echo "Instale k9s via 'go install' ou binário."
}

install_pkg() {
    [[ $# -gt 0 ]] || {
        echo "No package specified."
        return 1
    }

    sudo apt-get install -y "$@"
}
