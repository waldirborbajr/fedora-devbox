#!/usr/bin/env bash
install_lang() {
    log_info "Instalando ambiente Python..."
    install_pkg python3 python3-devel python3-pip
    python3 -m pip install --user pipx
    python3 -m pipx ensurepath
}