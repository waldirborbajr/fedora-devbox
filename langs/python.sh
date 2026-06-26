#!/usr/bin/env bash
install_lang() {
    log_info "Instalando ambiente Python..."
    # Instala o suporte básico e ferramentas de isolamento
    sudo dnf install -y python3-devel python3-pip || sudo apt install -y python3-dev python3-pip
    # Instala pipx para CLI tools isoladas
    python3 -m pip install --user pipx
    python3 -m pipx ensurepath
}