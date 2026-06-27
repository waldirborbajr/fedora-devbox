#!/usr/bin/env bash
# ============================================================
# manage.sh — Gerenciamento de containers do Devbox
# ============================================================
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source "${SCRIPT_DIR}/colors.sh"
[[ -f "${SCRIPT_DIR}/devbox.conf" ]] && source "${SCRIPT_DIR}/devbox.conf"

BOX_NAME="${BOX_NAME:-devbox}"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/devbox"

box_exists() {
    distrobox list --no-color 2>/dev/null | awk '{print $1}' | grep -qx "$BOX_NAME"
}

require_box() {
    if ! box_exists; then
        log_warn "Container '$BOX_NAME' não encontrado."
        return 1
    fi
}

action_list() {
    echo -e "${BLUE}=====================================================${NC}"
    echo -e "${BLUE}  Containers Distrobox (todos)${NC}"
    echo -e "${BLUE}=====================================================${NC}"
    distrobox list

    if box_exists; then
        local distro created
        distro="$(cat "${STATE_DIR}/distro" 2>/dev/null || echo "desconhecida")"
        created="$(podman inspect "$BOX_NAME" --format '{{.Created}}' 2>/dev/null || echo "desconhecido")"
        echo ""
        echo -e "${BLUE}-----------------------------------------------------${NC}"
        echo -e "Detalhes de '${GREEN}${BOX_NAME}${NC}':"
        echo -e "  Distro base : ${distro}"
        echo -e "  Criado em   : ${created}"
    fi
}

action_stop() {
    require_box || return 0
    log_info "Parando '${BOX_NAME}'..."
    distrobox stop "$BOX_NAME" --yes
    log_success "Container parado."
}

action_restart() {
    require_box || return 0
    log_info "Reiniciando '${BOX_NAME}'..."
    distrobox stop "$BOX_NAME" --yes 2>/dev/null || true
    distrobox enter "$BOX_NAME" -- true
    log_success "Container reiniciado."
}

action_info() {
    require_box || return 0
    echo -e "${BLUE}=====================================================${NC}"
    echo -e "${BLUE}  Info detalhada: ${BOX_NAME}${NC}"
    echo -e "${BLUE}=====================================================${NC}"
    podman inspect "$BOX_NAME" --format \
        'Status     : {{.State.Status}}
Imagem     : {{.Config.Image}}
Criado em  : {{.Created}}
Labels     : {{.Config.Labels}}
IP         : {{.NetworkSettings.IPAddress}}'
}

action_remove() {
    require_box || return 0
    "${SCRIPT_DIR}/remove.sh"
}

action_purge_all() {
    log_warn "Isso vai PARAR e REMOVER TODOS os containers podman desta máquina,"
    log_warn "não apenas o '${BOX_NAME}', e limpar imagens/volumes não usados."
    read -r -p "Digite o nome '${BOX_NAME}' para confirmar: " confirm
    if [[ "$confirm" != "$BOX_NAME" ]]; then
        log_warn "Confirmação não corresponde. Operação cancelada."
        return 0
    fi

    log_info "Parando todos os containers..."
    podman stop --all 2>/dev/null || true

    log_info "Removendo todos os containers..."
    podman rm --all --force 2>/dev/null || true

    log_info "Limpando imagens, volumes e redes não utilizados..."
    podman system prune --all --volumes --force

    log_info "Limpando estado do Devbox..."
    rm -rf "$STATE_DIR"

    log_success "Limpeza total concluída."
}

while true; do
    clear
    echo -e "${BLUE}=====================================================${NC}"
    echo -e "${BLUE}           🛠  GERENCIAMENTO DE CONTAINERS           ${NC}"
    echo -e "${BLUE}=====================================================${NC}"
    echo -e "  ${GREEN}1)${NC} Listar containers"
    echo -e "  ${GREEN}2)${NC} Parar o devbox"
    echo -e "  ${GREEN}3)${NC} Reiniciar o devbox"
    echo -e "  ${GREEN}4)${NC} Ver info detalhada do devbox"
    echo -e "  ${GREEN}5)${NC} Remover o devbox"
    echo -e "  ${RED}6)${NC} Limpar TUDO (todos os containers podman) ⚠️"
    echo -e "  ${RED}0)${NC} Sair"
    echo -e ""
    echo -e "${BLUE}=====================================================${NC}"
    read -r -p "Escolha [0-6]: " choice

    case "$choice" in
        1) action_list ;;
        2) action_stop ;;
        3) action_restart ;;
        4) action_info ;;
        5) action_remove ;;
        6) action_purge_all ;;
        0) break ;;
        *) log_error "Opção inválida." ;;
    esac

    echo ""
    read -r -p "Pressione Enter para continuar..."
done
