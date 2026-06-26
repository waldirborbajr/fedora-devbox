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

# Verifica se a biblioteca da distro existe
LIB_FILE="${SCRIPT_DIR}/lib/${DISTRO_TARGET}.sh"
if [[ ! -f "$LIB_FILE" ]]; then
    log_error "Biblioteca de distro não encontrada: $LIB_FILE"
    exit 1
fi
source "$LIB_FILE"

# Provisiona ferramentas base se necessário
if [[ ! -f "${STATE_DIR}/core_installed" ]]; then
    log_info "Provisionando ferramentas base..."
    install_core_tools
    touch "${STATE_DIR}/core_installed"
    log_success "Ferramentas base instaladas com sucesso."
fi

# --- Menu Visual de Linguagens ---
clear
echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE}             📦 CENTRAL DE LINGUAGENS               ${NC}"
echo -e "${BLUE}=====================================================${NC}"
echo -e "Selecione a tecnologia para instalar no ambiente:"
echo -e ""

# Lista os scripts de linguagem
mapfile -t options < <(find "${SCRIPT_DIR}/langs" -maxdepth 1 -type f -name "*.sh" -printf "%f\n" | sort)

if [[ ${#options[@]} -eq 0 ]]; then
    log_error "Nenhum script de linguagem encontrado em ${SCRIPT_DIR}/langs"
    exit 1
fi

# Exibe o menu
i=1
for lang in "${options[@]}"; do
    echo -e "  ${GREEN}${i})${NC} ${lang%.sh}"
    ((i++))
done

echo -e "  ${RED}0)${NC} Sair"
echo -e ""
echo -e "${BLUE}=====================================================${NC}"
read -r -p "Escolha sua opção [0-$((i-1))]: " choice

# Processamento da escolha
if [[ "$choice" == "0" ]]; then
    log_info "Saindo..."
    exit 0
fi

idx=$((choice-1))
selected_lang="${options[$idx]}"

if [[ -z "${selected_lang:-}" ]]; then
    log_error "Opção inválida."
    exit 1
fi

log_info "Iniciando instalação de: ${selected_lang%.sh}..."

# Carrega e executa a instalação
source "${SCRIPT_DIR}/langs/${selected_lang}"
if ! declare -F install_lang >/dev/null; then
    log_error "Função 'install_lang' não encontrada em ${selected_lang}"
    exit 1
fi

install_lang

# Registra instalação
touch "${STATE_DIR}/installed_langs"
grep -qxF "$selected_lang" "${STATE_DIR}/installed_langs" || echo "$selected_lang" >> "${STATE_DIR}/installed_langs"

# Executa o export para disponibilizar no host
"${SCRIPT_DIR}/exports.sh" "$selected_lang"

log_success "Instalação de '${selected_lang%.sh}' concluída."