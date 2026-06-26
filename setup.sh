# ============================================================
# setup.sh
# ============================================================
#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/devbox"

mkdir -p "$STATE_DIR"

DISTRO_TARGET="$(cat "${STATE_DIR}/distro" 2>/dev/null || echo "fedora")"

case "$DISTRO_TARGET" in
    fedora|ubuntu|arch)
        ;;
    *)
        echo "Invalid distro: $DISTRO_TARGET"
        exit 1
        ;;
esac

LIB_FILE="./lib/${DISTRO_TARGET}.sh"

if [[ ! -f "$LIB_FILE" ]]; then
    echo "Missing distro library: $LIB_FILE"
    exit 1
fi

source "$LIB_FILE"

if [[ ! -f "${STATE_DIR}/core_installed" ]]; then
    log "Provisioning core tools..."
    install_core_tools
    touch "${STATE_DIR}/core_installed"
fi

echo
echo "=== Language Menu ==="

mapfile -t options < <(
    find langs \
        -maxdepth 1 \
        -type f \
        -name "*.sh" \
        -printf "%f\n" \
        | sort
)

PS3="Choose an option (0 to exit): "

select lang in "${options[@]}"; do

    [[ "$REPLY" == "0" ]] && break

    [[ -z "${lang:-}" ]] && continue

    case "$lang" in
        *.sh)
            ;;
        *)
            echo "Invalid language file."
            continue
            ;;
    esac

    LANG_SCRIPT="langs/$lang"

    if [[ ! -f "$LANG_SCRIPT" ]]; then
        echo "Language file not found."
        continue
    fi

    log "Installing $lang..."

    source "$LANG_SCRIPT"

    if ! declare -F install_lang >/dev/null; then
        echo "install_lang function not found in $LANG_SCRIPT"
        exit 1
    fi

    install_lang

    touch "${STATE_DIR}/installed_langs"

    grep -qxF "$lang" "${STATE_DIR}/installed_langs" \
        || echo "$lang" >> "${STATE_DIR}/installed_langs"

    ./exports.sh "$lang"

    log "$lang installed and exported."

    break

done
