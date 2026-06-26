#!/usr/bin/env bash
# langs/go.sh

install_lang() {
    case "$DISTRO_TARGET" in
        fedora)
            install_pkg golang
            ;;
        ubuntu)
            install_pkg golang-go
            ;;
        arch)
            install_pkg go
            ;;
        *)
            echo "Unsupported distro: $DISTRO_TARGET"
            return 1
            ;;
    esac

    command -v go >/dev/null 2>&1 || {
        echo "Go installation failed."
        return 1
    }

    echo "Go $(go version | awk '{print $3}') installed successfully."
}
