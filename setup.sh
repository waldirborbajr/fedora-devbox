#!/usr/bin/env bash
set -euo pipefail

# Recupera o target ou assume fedora
if [[ -f /tmp/distro_target ]]; then
    DISTRO_TARGET=$(cat /tmp/distro_target)
else
    DISTRO_TARGET="fedora"
fi

source "./lib/${DISTRO_TARGET}.sh"

# --- Instalação Automática Core (apenas na primeira vez) ---
if [[ ! -f /tmp/core_installed ]]; then
    echo "=== Provisionando Core: ${DISTRO_TARGET} ==="
    install_core_tools
    touch /tmp/core_installed
else
    echo "=== Core já instalado. ==="
fi

# --- Menu Interativo de Linguagens ---
echo "=== Menu de Linguagens ==="
echo "Selecione uma linguagem para instalar (ou '0' para sair):"
options=($(ls langs/))

select lang in "${options[@]}"; do
  if [[ "$REPLY" == "0" ]]; then break; fi
  if [[ -f "langs/$lang" ]]; then
    echo "Instalando $lang..."
    source "langs/$lang"
    install_lang

    # Exporta apenas a linguagem instalada
    ./exports.sh "$lang"

    echo "✅ $lang instalado e exportado com sucesso."
    break
  else
    echo "Opção inválida."
  fi
done
