install_core_tools() {
  sudo dnf install -y git vim htop zoxide curl wget make gcc gcc-c++
}
install_pkg() { sudo dnf install -y "$@"; }
