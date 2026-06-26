#!/usr/bin/env bash

set -uo pipefail
# (sem -e: queremos seguir exportando/removendo o resto mesmo se um binário faltar)

# Uso: ./exports.sh           -> exporta os binários (comportamento padrão)
#      ./exports.sh --delete  -> desfaz os exports (remove os wrappers do host)
MODE="export"
if [[ "${1:-}" == "--delete" ]]; then
  MODE="delete"
fi

DEVBOX_MANIFEST="$HOME/.config/devbox/selections.env"

# Carrega o que foi escolhido na última execução do setup.sh.
# Se o manifesto não existir (ex: setup.sh antigo, ou rodado fora desse fluxo),
# cai no fallback de "exportar/remover se o binário existir", igual ao
# comportamento antigo.
HAS_MANIFEST=0
if [[ -f "$DEVBOX_MANIFEST" ]]; then
  # shellcheck disable=SC1090
  source "$DEVBOX_MANIFEST"
  HAS_MANIFEST=1
elif [[ "$MODE" == "export" ]]; then
  echo "⚠️  Manifesto de seleção não encontrado em $DEVBOX_MANIFEST."
  echo "   Rode setup.sh primeiro para registrar suas escolhas; por ora,"
  echo "   vou exportar qualquer binário que já existir no sistema."
fi

# export_if_exists <caminho ou nome de comando>
# Resolve o caminho via `command -v` quando recebe só um nome (ex: "mvn"),
# ou usa o caminho direto se já vier absoluto. Só age se o binário existir.
# Respeita $MODE: "export" publica o binário no host; "delete" remove o wrapper.
export_if_exists() {
  local target="$1"
  local resolved

  if [[ "$target" == /* ]]; then
    resolved="$target"
  else
    resolved="$(command -v "$target" 2>/dev/null || true)"
  fi

  if [[ -n "$resolved" && -x "$resolved" ]]; then
    if [[ "$MODE" == "delete" ]]; then
      echo "Removendo export: $resolved"
      distrobox-export --bin "$resolved" --delete
    else
      echo "Exportando: $resolved"
      distrobox-export --bin "$resolved"
    fi
  else
    echo "⚠️  Pulando '$target' (não instalado)"
  fi
}

# export_language <flag_var> <rotulo> <target1> [target2] [target3] ...
# Só age sobre os binários da linguagem se a flag do manifesto for 1.
# Sem manifesto (HAS_MANIFEST=0), cai no comportamento antigo: tenta agir
# e deixa export_if_exists decidir pela existência do binário.
export_language() {
  local flag_var="$1"
  local label="$2"
  shift 2

  if [[ "$HAS_MANIFEST" -eq 1 ]]; then
    local flag_value="${!flag_var:-0}"
    if [[ "$flag_value" -ne 1 ]]; then
      echo "⏭️  $label não foi selecionado no setup.sh — pulando."
      return
    fi
  fi

  local target
  for target in "$@"; do
    export_if_exists "$target"
  done
}

# ============================================================================
# Ferramentas core (sempre instaladas pelo setup.sh)
# ============================================================================

export_if_exists /usr/bin/nvim
export_if_exists /usr/bin/tmux
export_if_exists /usr/bin/kubectl
export_if_exists /usr/bin/terraform
export_if_exists /usr/bin/helm
export_if_exists /usr/bin/ansible
export_if_exists /usr/bin/aws
export_if_exists /usr/local/bin/yq

# ============================================================================
# Linguagens (instalação opcional/interativa no setup.sh)
# ============================================================================

export_language INSTALL_GO   "Go"   /usr/bin/go

# Rust (via rustup, fica em $HOME/.cargo/bin — não tem caminho fixo em /usr/bin)
export_language INSTALL_RUST "Rust" rustc cargo

export_language INSTALL_NODE "Node.js" /usr/bin/node /usr/bin/npm

export_language INSTALL_PHP  "PHP" /usr/bin/php /usr/bin/composer laravel

# Java / Maven / Gradle (via SDKMAN — exige sourcing do sdkman-init.sh
# antes deste script para que `which`/`command -v` os encontre)
if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
  # shellcheck disable=SC1090
  source "$HOME/.sdkman/bin/sdkman-init.sh"
fi
export_language INSTALL_JAVA "Java" java mvn gradle

echo
if [[ "$MODE" == "delete" ]]; then
  echo "Remoção dos exports concluída."
else
  echo "Exportação concluída."
fi
