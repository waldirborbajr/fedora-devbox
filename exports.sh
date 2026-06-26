#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source "${SCRIPT_DIR}/colors.sh"

if [[ $# -eq 0 ]]; then exit 0; fi
lang="$1"

export_bin() {
    local bin=$1
    local path="$(command -v "$bin" 2>/dev/null || true)"
    if [[ -n "$path" ]]; then
        log_info "Exportando '${bin}'..."
        distrobox-export --bin "$path" --export-path "$HOME/.local/bin"
    fi
}

case "$lang" in
    "utils")      export_bin "bat"; export_bin "fd"; export_bin "k9s" ;;
    "go.sh")      export_bin "go" ;;
    "nodes.sh")   export_bin "node"; export_bin "npm" ;;
    "rust.sh")    export_bin "cargo"; export_bin "rustc" ;;
    "php.sh")     export_bin "php"; export_bin "composer" ;;
    "java.sh")  
        distrobox-export --bin "$HOME/.sdkman/candidates/java/current/bin/java" --export-path "$HOME/.local/bin" || true
        distrobox-export --bin "$HOME/.sdkman/candidates/maven/current/bin/mvn" --export-path "$HOME/.local/bin" || true
        ;;
    *) log_warn "Linguagem '$lang' não configurada para exportação.";;
esac