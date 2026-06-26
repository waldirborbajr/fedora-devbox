# Distrobox Fedora DevBox

[Distrobox](https://github.com/89luca89/distrobox) cria containers que se integram perfeitamente com o sistema host — compartilhando diretório home, dispositivos USB, áudio, Wayland/X11 e systemd.

**Benefícios:**
- Ambiente de desenvolvimento isolado sem poluir o host
- Acesso direto a arquivos e ferramentas do container pelo terminal do host
- Múltiplos ambientes (Fedora, Ubuntu, Arch) lado a lado
- Ferramentas exportadas aparecem como se estivessem instaladas nativamente

## Estrutura do projeto

```
.
├── start.sh        # ponto de entrada: cria/entra no container
├── setup.sh        # menu de instalação de linguagens
├── exports.sh       # exporta um binário do container para o host
├── remove.sh       # remove o container e os binários exportados
├── colors.sh       # helpers de log coloridos (ANSI)
├── lib/            # scripts por distro (core tools + install_pkg)
│   ├── fedora.sh
│   ├── ubuntu.sh
│   └── arch.sh
└── langs/          # scripts por linguagem (install_lang)
    ├── go.sh
    ├── nodes.sh
    ├── php.sh
    ├── rust.sh
    └── java.sh
```

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

./start.sh
```

`start.sh` cria o container (perguntando a distro), executa `setup.sh` dentro dele e abre uma sessão interativa. Da segunda vez em diante, ele detecta o container existente e oferece entrar nele ou instalar mais linguagens.

Após instalar uma linguagem pelo menu, as ferramentas (`go`, `node`, `php`, `cargo`, `java`, etc.) estarão disponíveis tanto dentro do container quanto no terminal do próprio host, via exportação automática do Distrobox.

Para remover tudo (container + binários exportados):

```bash
./remove.sh
```

---

### SDKMAN

O `langs/java.sh` instala o [SDKMAN](https://sdkman.io) e a versão **mais recente** de Java, Maven e Gradle.

Para instalar uma versão específica (ex: Java 21):

```bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk list java           # lista versões disponíveis
sdk install java 21.0.2-tem
sdk default java 21.0.2-tem   # define como padrão
```
