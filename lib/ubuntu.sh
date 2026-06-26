#!/usr/bin/env bash
install_core_tools() { sudo apt update && sudo apt install -y git vim htop zoxide curl wget make gcc g++ podman; }
install_pkg() { sudo apt install -y "$@"; }
