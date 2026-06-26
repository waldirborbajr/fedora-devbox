#!/usr/bin/env bash

install_lang() {

    case "$DISTRO_TARGET" in
        fedora|ubuntu|arch)
            install_pkg php composer
            ;;
        *)
            echo "Unsupported distro: $DISTRO_TARGET"
            return 1
            ;;
    esac

    command -v php >/dev/null 2>&1 || {
        echo "PHP installation failed."
        return 1
    }

    command -v composer >/dev/null 2>&1 || {
        echo "Composer installation failed."
        return 1
    }

    if ! composer global show laravel/installer >/dev/null 2>&1; then
        composer global require laravel/installer
    fi

    echo "PHP $(php -r 'echo PHP_VERSION;') installed successfully."
    echo "Composer $(composer --version | awk '{print $3}') installed successfully."
}
