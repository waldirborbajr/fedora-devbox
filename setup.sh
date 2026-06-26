#!/usr/bin/env bash
# ============================================================
# setup.sh — Central de gerenciamento de linguagens
# ============================================================
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source "${SCRIPT_DIR}/colors.sh"
[[ -f "${SCRIPT_DIR}/devbox.conf" ]] && source "${SCRIPT_DIR}/devbox.conf"

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/devbox"
mkdir -p "$STATE_DIR"

DISTRO_TARGET="$(cat "${STATE_DIR}/distro" 2>/dev/null || echo "fedora")"

# 1. Carrega biblioteca da distro
LIB_FILE="${SCRIPT_DIR}/lib/${DISTRO_TARGET}.sh"
if [[ ! -f "$LIB_FILE" ]]; then
    log_error "Biblioteca de distro não encontrada: $LIB_FILE"
    exit 1
fi
source "$LIB_FILE"

# 2. Provisiona ferramentas base (apenas na primeira vez)
if [[ ! -f "${STATE_DIR}/core_installed" ]]; then
    log_info "Provisionando ferramentas base..."
    install_core_tools
    touch "${STATE_DIR}/core_installed"
    log_success "Ferramentas base instaladas."
fi

# 3. Menu Visual de Linguagens
while true; do
    clear
    echo -e "${BLUE}=====================================================${NC}"
    echo -e "${BLUE}             📦 CENTRAL DE LINGUAGENS               ${NC}"
    echo -e "${BLUE}=====================================================${NC}"
    echo -e "Selecione a tecnologia para instalar no ambiente:"
    echo -e ""

    mapfile -t options < <(find "${SCRIPT_DIR}/langs" -maxdepth 1 -type f -name "*.sh" -printf "%f\n" | sort)

    i=1
    for lang in "${options[@]}"; do
        echo -e "  ${GREEN}${i})${NC} ${lang%.sh}"
        ((i++))
    done

    echo -e "  ${RED}0)${NC} Sair / Finalizar"
    echo -e ""
    echo -e "${BLUE}=====================================================${NC}"
    read -r -p "Escolha [0-$((i-1))]: " choice

    [[ "$choice" == "0" ]] && break

    if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
        log_error "Opção inválida."
        sleep 1
        continue
    fi

    idx=$((choice-1))
    selected_lang="${options[$idx]:-}"

    if [[ -z "${selected_lang:-}" ]]; then
        log_error "Opção inválida."
        sleep 1
        continue
    fi

    log_info "Instalando: ${selected_lang%.sh}..."

    # Carrega e executa instalação
    source "${SCRIPT_DIR}/langs/${selected_lang}"
    install_lang

    # Registra e exporta
    touch "${STATE_DIR}/installed_langs"
    grep -qxF "$selected_lang" "${STATE_DIR}/installed_langs" || echo "$selected_lang" >> "${STATE_DIR}/installed_langs"
    
    # Audit Log
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Instalado: $selected_lang" >> "$STATE_DIR/audit.log"
    
    "${SCRIPT_DIR}/exports.sh" "$selected_lang"
    log_success "Instalação de '${selected_lang%.sh}' concluída."
    read -r -p "Pressione Enter para continuar..."
done

log_info "Setup finalizado."
