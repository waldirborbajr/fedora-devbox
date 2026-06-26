#!/usr/bin/env bash
install_lang() {
  case "$DISTRO_TARGET" in
    fedora|ubuntu) install_pkg nodejs npm ;;
    arch)          install_pkg nodejs npm ;;
  esac
}
