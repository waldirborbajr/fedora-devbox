#!/usr/bin/env bash

install_lang() {

    case "$DISTRO_TARGET" in
        fedora|ubuntu|arch)
            install_pkg nodejs npm
            ;;
        *)
            echo "Unsupported distro: $DISTRO_TARGET"
            return 1
            ;;
    esac

    command -v node >/dev/null 2>&1 || {
        echo "Node.js installation failed."
        return 1
    }

    command -v npm >/dev/null 2>&1 || {
        echo "NPM installation failed."
        return 1
    }

    echo "Node $(node --version) installed successfully."
    echo "NPM  $(npm --version) installed successfully."
}
