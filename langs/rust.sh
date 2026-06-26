#!/usr/bin/env bash

install_lang() {

    if [[ ! -d "$HOME/.cargo" ]]; then
        echo "Installing Rust..."

        curl --proto '=https' \
            --tlsv1.2 \
            -fsSL \
            https://sh.rustup.rs \
            | sh -s -- -y
    fi

    # shellcheck disable=SC1090
    source "$HOME/.cargo/env"

    rustup self update
    rustup update

    rustup component add rustfmt
    rustup component add clippy

    command -v rustc >/dev/null 2>&1 || {
        echo "Rust installation failed."
        return 1
    }

    command -v cargo >/dev/null 2>&1 || {
        echo "Cargo installation failed."
        return 1
    }

    echo "Rust $(rustc --version | awk '{print $2}') installed successfully."
}
