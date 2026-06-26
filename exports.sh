#!/usr/bin/env bash
# ============================================================
# exports.sh — Integração de binários Host <-> Container
# ============================================================
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source "${SCRIPT_DIR}/colors.sh"
[[ -f "${SCRIPT_DIR}/devbox.conf" ]] && source "${SCRIPT_DIR}/devbox.conf"

# Garante que o diretório de exportação existe no host
# Substituímos a variável para garantir expansão correta do $HOME
mkdir -p "${EXPORT_PATH/#$HOME/$HOME}"

if [[ $# -eq 0 ]]; then 
    log_warn "Nenhum parâmetro de linguagem fornecido para exportação."
    exit 0
fi

lang="$1"

# Função centralizada para exportar binários de forma segura
export_bin() {
    local bin=$1
    local path="$(command -v "$bin" 2>/dev/null || true)"
    if [[ -n "$path" ]]; then
        log_info "Exportando '${bin}' para ${EXPORT_PATH}..."
        distrobox-export --bin "$path" --export-path "${EXPORT_PATH/#$HOME/$HOME}"
    else
        log_warn "Binário '${bin}' não encontrado no container, ignorando exportação."
    fi
}

case "$lang" in
    # Utilidades Gerais
    "utils.sh")
        export_bin "bat"
        export_bin "fd"
        export_bin "k9s"
        ;;

    # Linguagens e Runtimes
    "python.sh")
        export_bin "python3"
        export_bin "pip3"
        ;;
        
    "go.sh")
        export_bin "go"
        ;;

    "nodes.sh")
        export_bin "node"
        export_bin "npm"
        ;;

    "rust.sh")
        export_bin "cargo"
        export_bin "rustc"
        ;;

    "php.sh")
        export_bin "php"
        export_bin "composer"
        ;;

    "java.sh")
        # Java/Maven SDKMAN (Caminho customizado)
        distrobox-export --bin "$HOME/.sdkman/candidates/java/current/bin/java" --export-path "${EXPORT_PATH/#$HOME/$HOME}" || true
        distrobox-export --bin "$HOME/.sdkman/candidates/maven/current/bin/mvn" --export-path "${EXPORT_PATH/#$HOME/$HOME}" || true
        ;;

    "lua.sh")
        export_bin "lua"
        export_bin "luarocks"
        ;;

    "infra.sh")
        export_bin "docker"
        export_bin "podman"
        export_bin "kubectl"
        export_bin "helm"
        ;;

    *) 
        log_warn "Linguagem/Plugin '$lang' não configurada para exportação."
        ;;
esac