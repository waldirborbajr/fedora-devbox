#!/usr/bin/env bash
install_lang() {
    log_info "Instalando ambiente Lua..."
    sudo dnf install -y lua luarocks || sudo apt install -y lua5.3 luarocks
}