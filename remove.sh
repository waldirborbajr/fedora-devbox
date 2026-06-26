# ============================================================
# remove.sh
# ============================================================
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
# shellcheck source=./colors.sh
source "${SCRIPT_DIR}/colors.sh"

BOX_NAME="devbox"

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/devbox"
LANG_FILE="${STATE_DIR}/installed_langs"

if ! distrobox list --no-color 2>/dev/null | awk '{print $1}' | grep -qx "$BOX_NAME"; then
    log_warn "Container not found."
    exit 0
fi

log_info "Removing exported binaries..."

if [[ -f "$LANG_FILE" ]]; then
    while read -r lang; do

        [[ -z "$lang" ]] && continue

        case "$lang" in
            go.sh)   bin_name="go" ;;
            nodes.sh) bin_name="node" ;;
            rust.sh) bin_name="cargo" ;;
            php.sh)  bin_name="php" ;;
            java.sh) bin_name="java" ;;
            *) continue ;;
        esac

        rm -f "$HOME/.local/bin/$bin_name"

    done < "$LANG_FILE"
fi

log_info "Removing container..."

distrobox rm "$BOX_NAME" --force

rm -rf "$STATE_DIR"

log_success "Cleanup completed."
