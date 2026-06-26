#!/usr/bin/env bash
set -euo pipefail

BOX_NAME="devbox"

# 1. Verifica se o container existe
if ! distrobox list --no-color 2>/dev/null | grep -q "$BOX_NAME"; then
  echo "Container '${BOX_NAME}' não existe. Nada a remover."
  exit 0
fi

echo "⚠️  Isso vai remover o container distrobox '${BOX_NAME}'."
echo "Essa ação não pode ser desfeita."
read -r -p "Confirma a remoção de '${BOX_NAME}'? [y/N] " reply
reply="${reply,,}"

case "$reply" in
  y|yes|s|sim) ;;
  *)
    echo "Cancelado. Nada foi removido."
    exit 0
    ;;
esac

# 2. Desfaz os exports, se o script existir
if [[ -f "./exports.sh" ]]; then
  echo "Desfazendo exports..."
  distrobox enter "${BOX_NAME}" -- bash -c "./exports.sh --delete" || true
fi

# 3. Remove o container
echo "Removendo container '${BOX_NAME}'..."
distrobox rm "${BOX_NAME}" --force

# 4. Remove o manifesto de seleções, se existir
DEVBOX_MANIFEST="$HOME/.config/devbox/selections.env"
if [[ -f "$DEVBOX_MANIFEST" ]]; then
  echo "Removendo manifesto de seleções ($DEVBOX_MANIFEST)..."
  rm -f "$DEVBOX_MANIFEST"
fi

echo "✅ Container '${BOX_NAME}' removido com sucesso."
