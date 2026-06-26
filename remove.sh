# ============================================================
# remove.sh
# ============================================================
#!/usr/bin/env bash
set -euo pipefail

BOX_NAME="devbox"

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/devbox"
LANG_FILE="${STATE_DIR}/installed_langs"

if ! distrobox list --no-color 2>/dev/null | awk '{print $1}' | grep -qx "$BOX_NAME"; then
    echo "Container not found."
    exit 0
fi

echo "Removing exported binaries..."

if [[ -f "$LANG_FILE" ]]; then
    while read -r lang; do

        [[ -z "$lang" ]] && continue

        case "$lang" in
            go.sh)   bin_name="go" ;;
            node.sh) bin_name="node" ;;
            rust.sh) bin_name="cargo" ;;
            php.sh)  bin_name="php" ;;
            java.sh) bin_name="java" ;;
            *) continue ;;
        esac

        rm -f "$HOME/.local/bin/$bin_name"

    done < "$LANG_FILE"
fi

echo "Removing container..."

distrobox rm "$BOX_NAME" --force

rm -rf "$STATE_DIR"

echo "✅ Cleanup completed."
