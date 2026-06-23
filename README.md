# Distrobox Fedora DevBox

[Distrobox](https://github.com/89luca89/distrobox) cria containers que se integram perfeitamente com o sistema host — compartilhando diretório home, dispositivos USB, áudio, Wayland/X11 e systemd.

**Benefícios:**
- Ambiente de desenvolvimento isolado sem poluir o host
- Acesso direto a arquivos e ferramentas do container pelo terminal do host
- Múltiplos ambientes (Fedora, Ubuntu, Arch) lado a lado
- Ferramentas exportadas aparecem como se estivessem instaladas nativamente

## Pré-requisitos

Instale Podman e Distrobox:

**Debian/Ubuntu:**
```bash
sudo apt update && sudo apt install podman distrobox -y
```

**Fedora:**
```bash
sudo dnf install podman distrobox -y
```

**Arch Linux:**
```bash
sudo pacman -S podman distrobox
```

## Quick start

```bash
git clone https://github.com/rmsaitam/fedora-devbox.git
cd fedora-devbox

distrobox create \
  --name fedora-dev \
  --image registry.fedoraproject.org/fedora:latest

distrobox enter fedora-dev

./setup.sh
./exports.sh
```

Após a execução, as ferramentas instaladas (`nvim`, `kubectl`, `terraform`, `php`, `aws`, etc.) estarão disponíveis no terminal do próprio host.

---

### SDKMAN

O `setup.sh` instala o [SDKMAN](https://sdkman.io) e a versão **mais recente** de Java, Maven e Gradle.

Para instalar uma versão específica (ex: Java 21):

```bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk list java           # lista versões disponíveis
sdk install java 21.0.2-tem
sdk default java 21.0.2-tem   # define como padrão
```
