#!/usr/bin/env bash
install_lang() {
    log_info "Instalando stack de Infra (Docker, K8s, etc)..."
    install_pkg docker podman k9s
    
    # Ferramentas via script seguem padrão universal
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
}