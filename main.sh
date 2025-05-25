#!/usr/bin/env bash

set -euo pipefail

_MAIN_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "${_MAIN_SCRIPT_DIR}/scripts/common.sh"

main() {
  local script_path=""

  local scripts_to_run=(
    "backup.sh"
    "packages.sh"
    "tools.sh"
    "symlinks.sh"
  )

  if [[ ${#scripts_to_run[@]} -eq 0 ]]; then
    exit 0
  fi

  for script_name in "${scripts_to_run[@]}"; do
    script_path="${_MAIN_SCRIPT_DIR}/scripts/${script_name}"

    if [[ ! -f "$script_path" ]]; then
      log_error "Script not found: $script_path. Aborting."
      exit 1
    fi

    echo "[main.sh] Running: ${script_name}"

    if ! (bash "$script_path"); then
      log_error "Script ${script_name} failed. Aborting."
      exit 1
    fi
  done

  echo "[main.sh] Dotfiles setup finished successfully."
  exit 0
}

main "$@"

