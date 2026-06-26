#!/usr/bin/env bash
install_lang() {
    log_info "Instalando ambiente Lua..."
    # Ajuste: nomes de pacotes podem variar, mas a função install_pkg é universal
    install_pkg lua luarocks
}