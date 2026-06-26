#!/usr/bin/bash
#
set -euo pipefail

BOX_NAME="fedora-dev"
BOX_IMAGE="registry.fedoraproject.org/fedora:latest"

# Cria o container apenas se ele ainda não existir (idempotente)
if ! distrobox list --no-color 2>/dev/null | grep -qE "^\s*${BOX_NAME}\b"; then
  distrobox create \
    --name "${BOX_NAME}" \
    --image "${BOX_IMAGE}"
fi

# Executa os scripts de setup DENTRO do container, sem abrir um shell interativo
distrobox enter "${BOX_NAME}" -- bash -c "./setup.sh && ./exports.sh"

# Só depois de tudo pronto, abre o shell interativo pra você usar o ambiente
distrobox enter "${BOX_NAME}"
