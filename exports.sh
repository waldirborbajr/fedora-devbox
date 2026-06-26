#!/usr/bin/env bash
# ============================================================
# exports.sh
# ============================================================
# Exports a single language's binary from inside the container
# to the host using distrobox-export.
#
# Usage: ./exports.sh <lang_file>
#   e.g. ./exports.sh go.sh

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
# shellcheck source=./colors.sh
source "${SCRIPT_DIR}/colors.sh"

if [[ $# -eq 0 ]]; then
    log_error "No language specified."
    echo "Usage: $0 <lang_file>"
    exit 1
fi

lang="$1"

case "$lang" in
    go.sh)   bin_name="go" ;;
    nodes.sh) bin_name="node" ;;
    rust.sh) bin_name="cargo" ;;
    php.sh)  bin_name="php" ;;
    java.sh) bin_name="java" ;;
    *)
        log_error "Unknown language file: $lang"
        exit 1
        ;;
esac

bin_path="$(command -v "$bin_name" 2>/dev/null || true)"

if [[ -z "$bin_path" ]]; then
    log_error "Binary '$bin_name' not found in PATH. Was $lang installed correctly?"
    exit 1
fi

log_info "Exporting '${bin_name}' to the host..."

if distrobox-export --bin "$bin_path"; then
    log_success "'${bin_name}' is now available on the host."
else
    log_error "Failed to export '${bin_name}'."
    exit 1
fi
