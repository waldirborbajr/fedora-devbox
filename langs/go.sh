# langs/go.sh
install_lang() {
  case "$DISTRO_TARGET" in
    fedora) install_pkg golang ;;
    ubuntu) install_pkg golang-go ;;
    arch)   install_pkg go ;;
  esac
}
