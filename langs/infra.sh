#!/usr/bin/env bash
install_lang() {
    log_info "Instalando stack de Infra (Docker, K8s, etc)..."
    # Docker/Podman
    sudo dnf install -y docker podman k9s || sudo apt install -y docker.io podman
    # Kubernetes tools
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    # Helm
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
}