#!/usr/bin/bash
#
set -euo pipefail

BOX_NAME="fedora-dev"
BOX_IMAGE="registry.fedoraproject.org/fedora:latest"

box_exists() {
  distrobox list --no-color 2>/dev/null | awk -F'|' -v name="$1" '
    { gsub(/^[ \t]+|[ \t]+$/, "", $2); if ($2 == name) found=1 }
    END { exit !found }
  '
}

# Cria o container apenas se ele ainda não existir (idempotente)
if ! box_exists "${BOX_NAME}"; then
  distrobox create \
    --name "${BOX_NAME}" \
    --image "${BOX_IMAGE}"
fi

# Executa os scripts de setup DENTRO do container, sem abrir um shell interativo
distrobox enter "${BOX_NAME}" -- bash -c "./setup.sh && ./exports.sh"

# Só depois de tudo pronto, abre o shell interativo pra você usar o ambiente
distrobox enter "${BOX_NAME}"
