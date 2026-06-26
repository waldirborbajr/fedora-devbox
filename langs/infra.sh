#!/usr/bin/env bash
install_lang() {
    log_info "Instalando stack de Infra (Docker, K8s, etc)..."

    # Nome do pacote docker varia por distro; podman é igual nas três.
    case "$DISTRO_TARGET" in
        fedora) install_pkg moby-engine ;;
        ubuntu) install_pkg docker.io ;;
        arch)   install_pkg docker ;;
        *)
            log_warn "Distro '$DISTRO_TARGET' não mapeada para o pacote docker, pulando."
            ;;
    esac
    install_pkg podman

    # kubectl: baixado em /tmp para não deixar lixo em $SCRIPT_DIR
    tmp_kubectl="$(mktemp -d)"
    curl -L -o "${tmp_kubectl}/kubectl" "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 "${tmp_kubectl}/kubectl" /usr/local/bin/kubectl
    rm -rf "$tmp_kubectl"

    # k9s: não está nos repos oficiais do Fedora/Ubuntu, instalado via binário da release
    tmp_k9s="$(mktemp -d)"
    curl -L -o "${tmp_k9s}/k9s.tar.gz" "https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz"
    tar -xzf "${tmp_k9s}/k9s.tar.gz" -C "$tmp_k9s" k9s
    sudo install -o root -g root -m 0755 "${tmp_k9s}/k9s" /usr/local/bin/k9s
    rm -rf "$tmp_k9s"

    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
}