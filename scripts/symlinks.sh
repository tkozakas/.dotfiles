#!/usr/bin/env bash

set -euo pipefail

_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "${_SCRIPT_DIR}/common.sh"

SYMLINK_CONFIG_FILE="${DOTFILES_DIR}/config/symlinks.conf"

main() {
    if [[ ! -f "$SYMLINK_CONFIG_FILE" ]]; then
        log_error "Symlink config file not found: $SYMLINK_CONFIG_FILE. Skipping."
        return 1
    fi

    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ -z "$line" ]]; then
            continue
        fi

        IFS=':' read -r source_suffix target_suffix <<< "$line"

        if [[ -z "$source_suffix" ]] || [[ -z "$target_suffix" ]]; then
            log_error "Invalid line in symlink config: $line"
            continue
        fi

        local source_path="${DOTFILES_DIR}/${source_suffix}"
        local target_path="${HOME}/${target_suffix}"

        if [[ ! -e "$source_path" ]]; then
            log_error "Symlink source not found: $source_path. Skipping."
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
    done < "$SYMLINK_CONFIG_FILE"
    return 0
}

main