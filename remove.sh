#!/usr/bin/env bash
#
set -euo pipefail

BOX_NAME="fedora-dev"
DEVBOX_MANIFEST="$HOME/.config/devbox/selections.env"

# ============================================================================
# Confirmação
# ============================================================================

box_exists() {
  distrobox list --no-color 2>/dev/null | awk -F'|' -v name="$1" '
    { gsub(/^[ \t]+|[ \t]+$/, "", $2); if ($2 == name) found=1 }
    END { exit !found }
  '
}

if ! box_exists "${BOX_NAME}"; then
  echo "Container '${BOX_NAME}' não existe. Nada a remover."
  exit 0
fi

echo "Isso vai remover o container distrobox '${BOX_NAME}' e desfazer os"
echo "binários exportados em ~/.local/bin, além do manifesto de seleções."
echo "Essa ação não pode ser desfeita."
echo
read -r -p "Confirma a remoção de '${BOX_NAME}'? [y/N] " reply
reply="${reply,,}"

case "$reply" in
  y|yes|s|sim) ;;
  *)
    echo "Cancelado. Nada foi removido."
    exit 0
    ;;
esac

# ============================================================================
# Desfaz os exports (wrappers em ~/.local/bin) antes de remover o container
# ============================================================================
#
# distrobox-export --delete precisa resolver o caminho do binário de dentro
# do container, então roda exports.sh em modo --delete lá dentro, se o
# script existir no diretório atual ou no $HOME do container.

if [[ -f "./exports.sh" ]]; then
  echo
  echo "Desfazendo exports anteriores..."
  distrobox enter "${BOX_NAME}" -- bash -c "./exports.sh --delete" || \
    echo "⚠️  Não foi possível desfazer todos os exports automaticamente (siga removendo o container)."
else
  echo "⚠️  exports.sh não encontrado no diretório atual — pulando limpeza de ~/.local/bin."
  echo "   Os wrappers exportados podem continuar em ~/.local/bin e precisarão ser removidos manualmente."
fi

# ============================================================================
# Remove o container
# ============================================================================

echo
echo "Removendo container '${BOX_NAME}'..."
distrobox rm "${BOX_NAME}" --force

# ============================================================================
# Remove o manifesto de seleções
# ============================================================================

if [[ -f "$DEVBOX_MANIFEST" ]]; then
  echo "Removendo manifesto de seleções ($DEVBOX_MANIFEST)..."
  rm -f "$DEVBOX_MANIFEST"
fi

echo
echo "✅ Container '${BOX_NAME}' removido com sucesso."
