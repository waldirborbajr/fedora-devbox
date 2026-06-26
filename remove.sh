#!/usr/bin/env bash
# ============================================================
# remove.sh — Limpeza segura e reversão de exports
# ============================================================
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source "${SCRIPT_DIR}/colors.sh"
[[ -f "${SCRIPT_DIR}/devbox.conf" ]] && source "${SCRIPT_DIR}/devbox.conf"

BOX_NAME="${BOX_NAME:-devbox}"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/devbox"

# Verifica se o container existe e é gerenciado por nós
if ! distrobox list --label "managed-by=devbox" 2>/dev/null | grep -q "$BOX_NAME"; then
    log_warn "Container '$BOX_NAME' não encontrado ou não gerenciado pelo Devbox."
    exit 0
fi

log_info "Iniciando processo de remoção..."

# 1. Remover exports registrados na pasta dedicada
if [[ -d "$EXPORT_PATH" ]]; then
    log_info "Limpando binários em $EXPORT_PATH..."
    rm -rf "$EXPORT_PATH"
fi

# 2. Remover container
log_info "Removendo container..."
distrobox rm "$BOX_NAME" --force

# 3. Remover registros de estado
rm -rf "$STATE_DIR"

log_success "Devbox removido com sucesso. O host foi limpo."