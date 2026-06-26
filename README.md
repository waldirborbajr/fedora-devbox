# ============================================================
# README.md - Devbox: Ambiente de Desenvolvimento Modular
# ============================================================

# O que é o Devbox?
O Devbox é uma solução de orquestração para Distrobox que permite criar ambientes de desenvolvimento isolados, reprodutíveis e configuráveis, mantendo a integração perfeita com o seu sistema host.

# Filosofia do Projeto
- Isolamento: Ferramentas de desenvolvimento contidas em containers, sem poluir o seu sistema operacional principal.
- Integração: Ferramentas instaladas dentro do container aparecem no seu terminal host como se fossem nativas.
- Modularidade: Instale apenas o que precisa. O Core é automático; linguagens são plugins.
- Segurança: Containers gerenciados com etiquetas (labels), garantindo que a limpeza seja segura e não afete outros projetos.

# Estrutura do Projeto

```sh
.
├── devbox.conf      # Configurações centralizadas (edite aqui)
├── install.sh       # Script de instalação inicial
├── start.sh         # Ponto de entrada: orquestra criação e acesso
├── setup.sh         # Menu interativo de instalação de linguagens
├── exports.sh       # Lógica de integração de binários (Host <-> Container)
├── remove.sh        # Limpeza segura (container + binários exportados)
├── colors.sh        # Helpers de logs coloridos
├── lib/             # Bibliotecas de sistema (scripts por distro)
│   ├── fedora.sh
│   ├── ubuntu.sh
│   └── arch.sh
└── langs/           # Plugins de linguagem (scripts de instalação)
    ├── go.sh
    ├── nodes.sh
    ├── php.sh
    ├── rust.sh
    ├── java.sh
    ├── python.sh
    ├── lua.sh
    └── infra.sh
```

# Pré-requisitos
Instale Podman e Distrobox conforme a sua distribuição:

Debian/Ubuntu:
  sudo apt update && sudo apt install podman distrobox -y

Fedora:
  sudo dnf install podman distrobox -y

Arch Linux:
  sudo pacman -S podman distrobox

# Configuração Importante (Isolamento)
Para que o seu host reconheça os binários exportados pelo Devbox, adicione o seguinte diretório ao seu arquivo de configuração de shell (ex: ~/.bashrc ou ~/.zshrc):

```sh
export PATH="$HOME/.local/devbox/bin:$PATH"
```

Após adicionar, execute `source ~/.bashrc` (ou o arquivo correspondente) para aplicar a mudança.

# Instalação
Para instalar o Devbox no seu sistema, execute o instalador:

```sh
chmod +x install.sh
sudo ./install.sh
```

Isso moverá os scripts para /opt/devbox e criará um link simbólico no /usr/local/bin, permitindo que você execute apenas "devbox" no terminal.

# Configuração
Antes de rodar pela primeira vez, abra o arquivo "devbox.conf" na raiz do projeto. Ele é o seu painel de controle:
- BOX_NAME: Nome do container (padrão: devbox).
- EXPORT_PATH: Onde os links dos programas serão criados no seu sistema (padrão: $HOME/.local/bin).

# Guia de Uso

1. Iniciar o Ambiente:
   Basta digitar "devbox" no terminal. Na primeira execução, você escolherá sua distribuição base.

2. Instalar mais Linguagens:
   Se o container já existir, ao digitar "devbox", escolha a opção 2 no menu para adicionar novas linguagens (elas serão baixadas e integradas automaticamente).

3. Remover o Ambiente:
   Para remover o container e limpar todos os binários exportados do seu computador:

```sh   
./remove.sh
```

# Como estender (Criar Plugins)
Para adicionar uma nova linguagem, basta criar um arquivo .sh na pasta langs/ seguindo o padrão de função 'install_lang'. O 'setup.sh' reconhecerá automaticamente o novo arquivo no menu.

# Troubleshooting
- Permissões: Certifique-se de que o seu usuário tem permissão para rodar podman sem sudo.
- Ambiente Corrompido: Se algo falhar, o script remove.sh garante uma limpeza segura.
- Logs de Erro: Em caso de falhas, consulte /tmp/devbox_debug.log para um diagnóstico detalhado.