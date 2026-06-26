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
LANG_FILE="${STATE_DIR}/installed_langs"

# Verifica se o container existe e é gerenciado por nós
if ! distrobox list --label "managed-by=devbox" 2>/dev/null | grep -q "$BOX_NAME"; then
    log_warn "Container '$BOX_NAME' não encontrado ou não gerenciado pelo Devbox."
    exit 0
fi

log_info "Iniciando processo de remoção..."

# 1. Remover exports registrados
if [[ -f "$LANG_FILE" ]]; then
    while read -r lang; do
        [[ -z "$lang" ]] && continue
        # Executa o export para remover (opcional: pode criar uma flag --delete no exports.sh)
        # Aqui removemos fisicamente os links criados pelo usuário
        case "$lang" in
            go.sh) rm -f "$HOME/.local/bin/go" ;;
            nodes.sh) rm -f "$HOME/.local/bin/node" "$HOME/.local/bin/npm" ;;
            rust.sh) rm -f "$HOME/.local/bin/cargo" "$HOME/.local/bin/rustc" ;;
            php.sh) rm -f "$HOME/.local/bin/php" "$HOME/.local/bin/composer" ;;
            java.sh) rm -f "$HOME/.local/bin/java" "$HOME/.local/bin/mvn" ;;
            utils) rm -f "$HOME/.local/bin/bat" "$HOME/.local/bin/fd" "$HOME/.local/bin/k9s" ;;
        esac
    done < "$LANG_FILE"
fi

# 2. Remover container
log_info "Removendo container..."
distrobox rm "$BOX_NAME" --force

# 3. Remover registros de estado
rm -rf "$STATE_DIR"

log_success "Devbox removido com sucesso. O host foi limpo."