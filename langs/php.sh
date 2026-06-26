#!/usr/bin/env bash
install_lang() {
  case "$DISTRO_TARGET" in
    fedora|ubuntu) install_pkg php composer ;;
    arch)          install_pkg php composer ;;
  esac
  composer global require laravel/installer
}
