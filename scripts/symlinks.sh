#!/usr/bin/env bash

set -euo pipefail

_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "${_SCRIPT_DIR}/.." && pwd)"

SYMLINK_CONFIG_FILE="${DOTFILES_DIR}/config/symlinks.conf"

if [[ ! -f "$SYMLINK_CONFIG_FILE" ]]; then
    echo "ERROR: Symlink config file not found: $SYMLINK_CONFIG_FILE." >&2
    exit 1
fi

while IFS=':' read -r source_suffix target_suffix || [[ -n "$line" ]]; do
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

    rm -rf "$target_path"
    mkdir -p "$(dirname "$target_path")"
    ln -s "$source_path" "$target_path"

done < <(grep -vE '^\s*$' "$SYMLINK_CONFIG_FILE" | grep -vE '^\s*#')

exit 0