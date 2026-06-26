#!/usr/bin/env bash
install_core_tools() { sudo pacman -Sy --noconfirm git vim htop zoxide curl wget make gcc podman; }
install_pkg() { sudo pacman -S --noconfirm "$@"; }
