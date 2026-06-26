#!/usr/bin/env bash

install_core_tools() {
    local packages=(
        git curl wget jq vim neovim htop tree ripgrep fzf zip unzip tmux make gcc gcc-c++ bat fd-find
    )
    sudo dnf install -y "${packages[@]}"
}

install_pkg() {
    [[ $# -gt 0 ]] || {
        echo "No package specified."
        return 1
    }
    sudo dnf install -y "$@"
}