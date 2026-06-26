# ============================================================
# start.sh
# ============================================================
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
# shellcheck source=./colors.sh
source "${SCRIPT_DIR}/colors.sh"

BOX_NAME="devbox"

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/devbox"

mkdir -p "$STATE_DIR"

if ! command -v distrobox >/dev/null 2>&1; then
    log_error "distrobox is not installed."
    exit 1
fi

box_exists() {
    distrobox list --no-color 2>/dev/null \
        | awk '{print $1}' \
        | grep -qx "$1"
}

if box_exists "$BOX_NAME"; then

    echo "1) Enter container"
    echo "2) Install more languages"

    read -r -p "Option [1/2]: " choice

    case "$choice" in
        1)
            ;;
        2)
            distrobox enter "$BOX_NAME" -- bash -c "cd '${SCRIPT_DIR}' && ./setup.sh"
            ;;
        *)
            log_error "Invalid option"
            exit 1
            ;;
    esac

else

    echo "Select distribution:"
    echo "1) Fedora"
    echo "2) Ubuntu"
    echo "3) Arch"

    read -r -p "Option [1-3]: " dist_choice

    case "$dist_choice" in
        1)
            IMG="registry.fedoraproject.org/fedora:latest"
            DIST="fedora"
            ;;
        2)
            IMG="ubuntu:latest"
            DIST="ubuntu"
            ;;
        3)
            IMG="archlinux:latest"
            DIST="arch"
            ;;
        *)
            log_error "Invalid option"
            exit 1
            ;;
    esac

    echo "$DIST" > "${STATE_DIR}/distro"

    log_info "Creating container..."

    if ! distrobox create \
        --name "$BOX_NAME" \
        --image "$IMG"; then

        log_error "Failed to create container."
        exit 1
    fi

    log_success "Container created."

    distrobox enter "$BOX_NAME" -- bash -c "
        mkdir -p '${STATE_DIR}' &&
        echo '${DIST}' > '${STATE_DIR}/distro' &&
        cd '${SCRIPT_DIR}' &&
        ./setup.sh
    "
fi

distrobox enter "$BOX_NAME"
