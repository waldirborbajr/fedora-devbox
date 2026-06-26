#!/usr/bin/env bash

install_lang() {

    if [[ ! -d "$HOME/.sdkman" ]]; then
        echo "Installing SDKMAN..."

        curl --proto '=https' \
            --tlsv1.2 \
            -fsSL \
            https://get.sdkman.io \
            | bash
    fi

    # shellcheck disable=SC1091
    source "$HOME/.sdkman/bin/sdkman-init.sh"

    sdk install java
    sdk install maven
    sdk install gradle

    command -v java >/dev/null 2>&1 || {
        echo "Java installation failed."
        return 1
    }

    command -v mvn >/dev/null 2>&1 || {
        echo "Maven installation failed."
        return 1
    }

    command -v gradle >/dev/null 2>&1 || {
        echo "Gradle installation failed."
        return 1
    }

    echo "Java ecosystem installed successfully."
}
