#!/usr/bin/env bash
LANG_FILE=$1
case "$LANG_FILE" in
    "go.sh") distrobox-export --bin "/usr/bin/go" --export-path "$HOME/.local/bin" ;;
    "node.sh") distrobox-export --bin "/usr/bin/node" --export-path "$HOME/.local/bin" ;;
    "rust.sh") distrobox-export --bin "$HOME/.cargo/bin/cargo" --export-path "$HOME/.local/bin" ;;
    "php.sh") distrobox-export --bin "/usr/bin/php" --export-path "$HOME/.local/bin" ;;
    "java.sh") distrobox-export --bin "$HOME/.sdkman/candidates/java/current/bin/java" --export-path "$HOME/.local/bin" ;;
esac
