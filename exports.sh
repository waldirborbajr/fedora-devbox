#!/usr/bin/env bash
# Uso: ./exports.sh [nome_da_lang]

LANG_TO_EXPORT=$1

case "$LANG_TO_EXPORT" in
    "go.sh")
        distrobox-export --bin "/usr/bin/go" --export-path "$HOME/.local/bin"
        ;;
    "node.sh")
        distrobox-export --bin "/usr/bin/node" --export-path "$HOME/.local/bin"
        distrobox-export --bin "/usr/bin/npm" --export-path "$HOME/.local/bin"
        ;;
    "rust.sh")
        # Cargo instalado via rustup geralmente fica em $HOME/.cargo/bin
        distrobox-export --bin "$HOME/.cargo/bin/cargo" --export-path "$HOME/.local/bin"
        distrobox-export --bin "$HOME/.cargo/bin/rustc" --export-path "$HOME/.local/bin"
        ;;
    "php.sh")
        distrobox-export --bin "/usr/bin/php" --export-path "$HOME/.local/bin"
        distrobox-export --bin "/usr/bin/composer" --export-path "$HOME/.local/bin"
        ;;
    "java.sh")
        # SDKMAN exporta os binários dinamicamente
        distrobox-export --bin "$HOME/.sdkman/candidates/java/current/bin/java" --export-path "$HOME/.local/bin"
        distrobox-export --bin "$HOME/.sdkman/candidates/maven/current/bin/mvn" --export-path "$HOME/.local/bin"
        ;;
    *)
        echo "Linguagem $LANG_TO_EXPORT não configurada para exportação automática."
        ;;
esac
