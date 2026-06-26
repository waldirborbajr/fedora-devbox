#!/usr/bin/env bash
# ============================================================
# start.sh — Gerenciador de ciclo de vida do Devbox
# ============================================================
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source "${SCRIPT_DIR}/colors.sh"
[[ -f "${SCRIPT_DIR}/devbox.conf" ]] && source "${SCRIPT_DIR}/devbox.conf"

BOX_NAME="${BOX_NAME:-devbox}"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/devbox"
mkdir -p "$STATE_DIR"

# 1. Verificação de Dependências
check_deps() {
    for cmd in podman distrobox; do
        if ! command -v "$cmd" &> /dev/null; then
            log_error "Dependência ausente: $cmd"
            echo -e "${YELLOW}Por favor, instale-o antes de continuar.${NC}"
            exit 1
        fi
    done
}
check_deps

# 2. Verificação de Saúde
box_exists() {
    distrobox list --no-color 2>/dev/null | awk '{print $1}' | grep -qx "$BOX_NAME"
}

if box_exists "$BOX_NAME"; then
    log_info "Container '${BOX_NAME}' detectado."
    
    # Check de saúde simples
    if ! distrobox enter "$BOX_NAME" -- true 2>/dev/null; then
        log_warn "O container existe, mas não respondeu. Tentando reiniciar..."
        distrobox stop "$BOX_NAME" --yes 2>/dev/null || true
        distrobox start "$BOX_NAME"
    fi

    clear
    echo -e "${BLUE}=====================================================${NC}"
    echo -e "${BLUE}                🚀 DEVBOX GESTÃO                     ${NC}"
    echo -e "${BLUE}=====================================================${NC}"
    echo -e "  ${GREEN}1)${NC} Entrar no ambiente"
    echo -e "  ${GREEN}2)${NC} Instalar novas linguagens"
    echo -e ""
    echo -e "${BLUE}=====================================================${NC}"
    read -r -p "Escolha [1/2]: " choice

    case "$choice" in
        1) distrobox enter "$BOX_NAME" ;;
        2) distrobox enter "$BOX_NAME" -- bash -c "cd '${SCRIPT_DIR}' && ./setup.sh" ;;
        *) log_error "Opção inválida."; exit 1 ;;
    esac
else
    clear
    echo -e "${BLUE}=====================================================${NC}"
    echo -e "${BLUE}          ✨ CONFIGURAÇÃO INICIAL DEVBOX            ${NC}"
    echo -e "${BLUE}=====================================================${NC}"
    echo -e "Selecione a distribuição base para o seu container:"
    echo -e ""
    echo -e "  ${GREEN}1)${NC} Fedora"
    echo -e "  ${GREEN}2)${NC} Ubuntu"
    echo -e "  ${GREEN}3)${NC} Arch Linux"
    echo -e ""
    echo -e "${BLUE}=====================================================${NC}"
    read -r -p "Opção [1-3]: " dist_choice

    case "$dist_choice" in
        1) IMG="registry.fedoraproject.org/fedora:latest"; DIST="fedora" ;;
        2) IMG="ubuntu:latest"; DIST="ubuntu" ;;
        3) IMG="archlinux:latest"; DIST="arch" ;;
        *) log_error "Opção inválida."; exit 1 ;;
    esac

    echo "$DIST" > "${STATE_DIR}/distro"
    
    log_info "Criando container '${BOX_NAME}' com imagem ${IMG}..."
    distrobox create -n "$BOX_NAME" -i "$IMG" --label "managed-by=devbox"
    
    log_success "Container criado! Iniciando provisionamento..."
    distrobox enter "$BOX_NAME" -- bash -c "cd '${SCRIPT_DIR}' && ./setup.sh"
fi