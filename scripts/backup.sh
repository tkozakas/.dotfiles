#!/usr/bin/env bash
set -euo pipefail

_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "${_SCRIPT_DIR}/common.sh"

SYMLINKS_CONF="${DOTFILES_DIR}/config/symlinks.conf"
BACKUP_DEST_BASE="${HOME}/.dotfiles_backup"

main() {
  [[ -f "$SYMLINKS_CONF" ]] || {
    log_error "Symlinks config not found: $SYMLINKS_CONF"
    return 1
  }
  current_backup_dir="${BACKUP_DEST_BASE}_$(date +%Y%m%d%H%M%S)"
  mkdir -p "$current_backup_dir"
  echo "Backing up to $current_backup_dir"

  while IFS=: read -r repo_subdir home_path || [[ -n "$repo_subdir" ]]; do
    [[ -z "${repo_subdir// /}" ]] && continue
    [[ "$repo_subdir" =~ ^\s*# ]] && continue
    src="$HOME/$home_path"
    if [[ -L "$src" ]]; then
      dest="$current_backup_dir/$home_path"
      mkdir -p "$(dirname "$dest")"
      mv "$src" "$dest"
    fi
  done <"$SYMLINKS_CONF"

  return 0
}

main
