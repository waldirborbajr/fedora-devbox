#!/usr/bin/env bash

install_core_tools() {
    local packages=(
        git
        vim
        htop
        zoxide
        curl
        wget
        make
        gcc
        base-devel
        unzip
        tar
        jq
        tree
        which
        bash-completion
        ca-certificates
        podman
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
