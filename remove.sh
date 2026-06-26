#!/usr/bin/env bash
set -euo pipefail
BOX_NAME="devbox"

if ! distrobox list --no-color 2>/dev/null | grep -q "$BOX_NAME"; then
    echo "Container não encontrado."
    exit 0
fi

echo "Removendo atalhos..."
if [[ -f /tmp/installed_langs_list ]]; then
    while read -r lang; do
        bin_name=${lang%.*}
        rm -f "$HOME/.local/bin/$bin_name"
    done < /tmp/installed_langs_list
fi

echo "Removendo container..."
distrobox rm "$BOX_NAME" --force
rm -f /tmp/core_installed /tmp/distro_target /tmp/installed_langs_list 2>/dev/null
echo "✅ Limpeza concluída."
