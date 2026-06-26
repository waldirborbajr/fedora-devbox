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
        gcc-c++
        unzip
        tar
        which
        findutils
        procps-ng
        bash-completion
        ca-certificates
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
