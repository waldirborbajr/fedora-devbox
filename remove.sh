#!/usr/bin/env bash
set -euo pipefail

BOX_NAME="devbox"

# 1. Verifica se o container existe
if ! distrobox list --no-color 2>/dev/null | grep -q "$BOX_NAME"; then
  echo "Container '$BOX_NAME' não encontrado."
  exit 0
fi

echo "⚠️  Você está prestes a remover o container '$BOX_NAME'."
read -r -p "Tem certeza? [s/N] " confirm
[[ "${confirm,,}" =~ ^(s|sim)$ ]] || exit 0

# 2. Limpeza dos exports (opcional: remove binários exportados)
echo "Limpando atalhos exportados..."
# Remove links simbólicos de ferramentas conhecidas em ~/.local/bin
# Ajuste as ferramentas conforme necessário
rm -f "$HOME/.local/bin/go" "$HOME/.local/bin/node" "$HOME/.local/bin/php" "$HOME/.local/bin/composer" "$HOME/.local/bin/cargo" 2>/dev/null

# 3. Remove o container
echo "Removendo container '$BOX_NAME'..."
distrobox rm "$BOX_NAME" --force

# 4. Remove arquivos temporários dentro do container (opcional: limpar manifestos)
rm -f /tmp/core_installed /tmp/distro_target 2>/dev/null

echo "✅ Container removido com sucesso."
