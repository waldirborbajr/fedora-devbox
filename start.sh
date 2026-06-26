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

if box_exists "${BOX_NAME}"; then
  echo "O container '${BOX_NAME}' já existe."
  echo "Escolha uma opção:"
  echo "1) Entrar no container"
  echo "2) Instalar mais linguagens/ferramentas"
  read -r -p "Opção [1/2]: " opcao

  if [[ "$opcao" == "2" ]]; then
    # Executa o setup.sh novamente dentro do container para novas seleções
    distrobox enter "${BOX_NAME}" -- bash -c "./setup.sh && ./exports.sh"
  fi
else
  # Container não existe, cria do zero
  distrobox create --name "${BOX_NAME}" --image "${BOX_IMAGE}"
  distrobox enter "${BOX_NAME}" -- bash -c "./setup.sh && ./exports.sh"
fi

# Entra no container ao final
distrobox enter "${BOX_NAME}"
