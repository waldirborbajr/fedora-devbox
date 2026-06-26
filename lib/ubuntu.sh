#!/usr/bin/env bash

install_core_tools() {
    export DEBIAN_FRONTEND=noninteractive
    sudo apt-get update
    local packages=(
        git curl wget jq vim neovim htop tree ripgrep fzf zip unzip tmux make build-essential bat fd-find
    )
    sudo apt-get install -y "${packages[@]}"
}

install_pkg() {
    [[ $# -gt 0 ]] || {
        echo "No package specified."
        return 1
    }
    sudo apt-get install -y "$@"
}