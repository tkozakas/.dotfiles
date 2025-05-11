#!/usr/bin/env bash

set -euo pipefail

_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "${_SCRIPT_DIR}/common.sh"

SYMLINK_CONFIG_FILE="${DOTFILES_DIR}/config/symlinks.conf"

if [[ ! -f "$SYMLINK_CONFIG_FILE" ]]; then
    log_error "Symlink config file not found: $SYMLINK_CONFIG_FILE."
    exit 1
fi

while IFS=':' read -r source_suffix target_suffix; do
    if [[ -z "$source_suffix" || -z "$target_suffix" ]]; then
        continue
    fi

    source_path="${DOTFILES_DIR}/${source_suffix}"
    target_path="${HOME}/${target_suffix}"

    if [[ ! -e "$source_path" ]]; then
        continue
    fi

    if [[ -L "$target_path" ]] && [[ "$(readlink "$target_path")" == "$source_path" ]]; then
        continue
    fi

    if [[ -e "$target_path" ]] || [[ -L "$target_path" ]]; then
        rm -rf "$target_path"
    fi

    mkdir -p "$(dirname "$target_path")"
    ln -s "$source_path" "$target_path"

done < <(grep -vE '^\s*(#|$)' "$SYMLINK_CONFIG_FILE")

exit 0