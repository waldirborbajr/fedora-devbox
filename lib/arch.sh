#!/usr/bin/env bash

install_core_tools() {
    local packages=(
        git curl wget jq vim neovim htop tree ripgrep fzf zip unzip tmux make base-devel
    )
    sudo pacman -S --needed --noconfirm "${packages[@]}"
}

install_pkg() {
    [[ $# -gt 0 ]] || {
        echo "No package specified."
        return 1
    }
    sudo pacman -S --needed --noconfirm "$@"
}