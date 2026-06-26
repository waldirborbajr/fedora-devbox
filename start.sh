#!/usr/bin/env bash
BOX_NAME="devbox"

box_exists() {
  distrobox list --no-color 2>/dev/null | grep -q "$1"
}

if box_exists "$BOX_NAME"; then
  echo "Container '$BOX_NAME' detectado."
  echo "1) Entrar no container"
  echo "2) Instalar mais linguagens"
  read -r -p "Opção [1/2]: " choice

  if [[ "$choice" == "2" ]]; then
     distrobox enter "$BOX_NAME" -- bash -c "./setup.sh"
  fi
else
  echo "Criando novo container $BOX_NAME..."
  echo "Selecione a distro: 1) Fedora | 2) Ubuntu | 3) Arch"
  read -r -p "Opção [1-3]: " dist_choice
  case "$dist_choice" in
    1) IMG="registry.fedoraproject.org/fedora:latest"; DIST="fedora" ;;
    2) IMG="ubuntu:latest"; DIST="ubuntu" ;;
    3) IMG="archlinux:latest"; DIST="arch" ;;
    *) echo "Inválido"; exit 1 ;;
  esac

  distrobox create -n "$BOX_NAME" -i "$IMG"
  distrobox enter "$BOX_NAME" -- bash -c "echo '$DIST' > /tmp/distro_target && ./setup.sh"
fi

distrobox enter "$BOX_NAME"
