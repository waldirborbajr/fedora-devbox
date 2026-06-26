# ============================================================
# setup.sh
# ============================================================
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
# shellcheck source=./colors.sh
source "${SCRIPT_DIR}/colors.sh"

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/devbox"

mkdir -p "$STATE_DIR"

DISTRO_TARGET="$(cat "${STATE_DIR}/distro" 2>/dev/null || echo "fedora")"

case "$DISTRO_TARGET" in
    fedora|ubuntu|arch)
        ;;
    *)
        log_error "Invalid distro: $DISTRO_TARGET"
        exit 1
        ;;
esac

LIB_FILE="${SCRIPT_DIR}/lib/${DISTRO_TARGET}.sh"

if [[ ! -f "$LIB_FILE" ]]; then
    log_error "Missing distro library: $LIB_FILE"
    exit 1
fi

source "$LIB_FILE"

if [[ ! -f "${STATE_DIR}/core_installed" ]]; then
    log_info "Provisioning core tools..."
    install_core_tools
    touch "${STATE_DIR}/core_installed"
    log_success "Core tools provisioned."
fi

echo
echo "=== Language Menu ==="

mapfile -t options < <(
    find "${SCRIPT_DIR}/langs" \
        -maxdepth 1 \
        -type f \
        -name "*.sh" \
        -printf "%f\n" \
        | sort
)

if [[ ${#options[@]} -eq 0 ]]; then
    log_error "No language scripts found in ${SCRIPT_DIR}/langs"
    exit 1
fi

PS3="Choose an option (0 to exit): "

select lang in "${options[@]}"; do

    [[ "$REPLY" == "0" ]] && break

    [[ -z "${lang:-}" ]] && continue

    case "$lang" in
        *.sh)
            ;;
        *)
            log_warn "Invalid language file."
            continue
            ;;
    esac

    LANG_SCRIPT="${SCRIPT_DIR}/langs/$lang"

    if [[ ! -f "$LANG_SCRIPT" ]]; then
        log_error "Language file not found."
        continue
    fi

    log_info "Installing $lang..."

    source "$LANG_SCRIPT"

    if ! declare -F install_lang >/dev/null; then
        log_error "install_lang function not found in $LANG_SCRIPT"
        exit 1
    fi

    install_lang

    touch "${STATE_DIR}/installed_langs"

    grep -qxF "$lang" "${STATE_DIR}/installed_langs" \
        || echo "$lang" >> "${STATE_DIR}/installed_langs"

    if [[ ! -f "${STATE_DIR}/core_installed" ]]; then
        log_info "Provisioning core tools..."
        install_core_tools
        # Exporta o Core automaticamente na primeira vez
        "${SCRIPT_DIR}/exports.sh" "utils" 
        touch "${STATE_DIR}/core_installed"
        log_success "Core tools provisioned and exported."
    fi

    "${SCRIPT_DIR}/exports.sh" "$lang"

    log_success "$lang installed and exported."

    break

done
