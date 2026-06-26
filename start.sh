#!/usr/bin/env bash
# ============================================================
# start.sh — Gerenciador de ciclo de vida do Devbox
# ============================================================
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source "${SCRIPT_DIR}/colors.sh"
# Carrega configurações centralizadas
[[ -f "${SCRIPT_DIR}/devbox.conf" ]] && source "${SCRIPT_DIR}/devbox.conf"

BOX_NAME="${BOX_NAME:-devbox}"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/devbox"
mkdir -p "$STATE_DIR"

# Check de saúde (telemetria básica)
if ! command -v distrobox >/dev/null 2>&1; then
    log_error "Distrobox não está instalado no host."
    exit 1
fi

box_exists() {
    distrobox list --no-color 2>/dev/null | awk '{print $1}' | grep -qx "$BOX_NAME"
}

if box_exists "$BOX_NAME"; then
    log_info "Container '$BOX_NAME' já configurado."
    echo "1) Entrar no container"
    echo "2) Instalar mais linguagens"
    read -r -p "Escolha [1/2]: " choice

    case "$choice" in
        1) ;; # Segue para o enter
        2) distrobox enter "$BOX_NAME" -- bash -c "cd '${SCRIPT_DIR}' && ./setup.sh" ;;
        *) log_error "Opção inválida."; exit 1 ;;
    esac
else
    echo "=== Configuração Inicial ==="
    echo "Selecione a distribuição:"
    echo "1) Fedora | 2) Ubuntu | 3) Arch"
    read -r -p "Opção [1-3]: " dist_choice

    case "$dist_choice" in
        1) IMG="registry.fedoraproject.org/fedora:latest"; DIST="fedora" ;;
        2) IMG="ubuntu:latest"; DIST="ubuntu" ;;
        3) IMG="archlinux:latest"; DIST="arch" ;;
        *) log_error "Opção inválida."; exit 1 ;;
    esac

    echo "$DIST" > "${STATE_DIR}/distro"
    log_info "Criando container com label de gerenciamento..."

    distrobox create --name "$BOX_NAME" --label "managed-by=devbox" --image "$IMG"
    
    distrobox enter "$BOX_NAME" -- bash -c "
        mkdir -p '${STATE_DIR}' && 
        echo '${DIST}' > '${STATE_DIR}/distro' && 
        cd '${SCRIPT_DIR}' && ./setup.sh
    "
fi

distrobox enter "$BOX_NAME"