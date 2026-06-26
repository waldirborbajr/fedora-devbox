#!/usr/bin/env bash

install_core_tools() {
    local packages=(
        git curl wget jq vim neovim htop tree ripgrep fzf zip unzip tmux make gcc gcc-c++ 
        podman ansible terraform kubectl helm awscli redis gh bat fd-find
    )
    sudo dnf install -y "${packages[@]}"
    # k9s para Fedora costuma vir via dnf ou snap/binário
    sudo dnf install -y k9s || echo "k9s não disponível nos repos, instale via binário."
}

install_pkg() {
    [[ $# -gt 0 ]] || {
        echo "No package specified."
        return 1
    }

    sudo dnf install -y "$@"
}
