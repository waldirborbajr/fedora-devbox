#!/usr/bin/env bash
set -euo pipefail
GREEN='\033[0;32m'; NC='\033[0m'
log() { echo -e "${GREEN}[INFO]${NC} $1"; }

DISTRO_TARGET=$(cat /tmp/distro_target 2>/dev/null || echo "fedora")
source "./lib/${DISTRO_TARGET}.sh"

if [[ ! -f /tmp/core_installed ]]; then
    log "Provisionando Core..."
    install_core_tools
    touch /tmp/core_installed
fi

echo "=== Menu de Linguagens ==="
options=($(ls langs/))
select lang in "${options[@]}"; do
    if [[ "$REPLY" == "0" ]]; then break; fi
    if [[ -f "langs/$lang" ]]; then
        log "Instalando $lang..."
        source "langs/$lang"
        install_lang
        echo "$lang" >> /tmp/installed_langs_list
        ./exports.sh "$lang"
        log "$lang instalado e exportado."
        break
    fi
done
