#!/usr/bin/env bash

set -euo pipefail

_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "${_SCRIPT_DIR}/common.sh"

BACKUP_CONFIG_FILE="${DOTFILES_DIR}/config/backup.conf"
BACKUP_DEST_BASE="${HOME}/.dotfiles_backup"

main() {
    if [[ ! -f "$BACKUP_CONFIG_FILE" ]]; then
        log_error "Backup config file not found: $BACKUP_CONFIG_FILE."
        return 1
    fi

    local current_backup_dir="${BACKUP_DEST_BASE}_$(date +%Y%m%d%H%M%S)"
    mkdir -p "$current_backup_dir"

    while IFS= read -r item_path || [[ -n "$item_path" ]]; do
        if [[ -z "$item_path" || "$item_path" =~ ^\s*# ]]; then
            continue
        fi

        local source_item="${HOME}/${item_path}"
        local dest_item_path="${current_backup_dir}/${item_path}"

        if [[ -e "$source_item" ]]; then
            if [[ -L "$source_item" ]]; then
                continue
            fi
            mkdir -p "$(dirname "$dest_item_path")"
            mv "$source_item" "$dest_item_path"
        fi
    done < "$BACKUP_CONFIG_FILE"
    return 0
}

main