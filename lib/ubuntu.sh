#!/usr/bin/env bash

install_core_tools() {
    export DEBIAN_FRONTEND=noninteractive

    sudo apt-get update

    local packages=(
        git
        vim
        htop
        zoxide
        curl
        wget
        make
        gcc
        g++
        unzip
        tar
        jq
        tree
        ca-certificates
        bash-completion
        software-properties-common
        build-essential
        pkg-config
        podman
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
