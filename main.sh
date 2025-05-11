#!/usr/bin/env bash

set -euo pipefail

_MAIN_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "${_MAIN_SCRIPT_DIR}/scripts/common.sh"

run_script() {
    local script_name="$1"
    local script_path="${_MAIN_SCRIPT_DIR}/scripts/${script_name}"

    if [[ ! -f "$script_path" ]]; then
        log_error "Script not found: $script_path."
        return 1
    fi

    log_info "Running: ${script_name}"

    if (bash "$script_path"); then
        return 0
    else
        log_error "Script ${script_name} failed."
        return 1
    fi
}

main() {
    log_info "Starting dotfiles setup..."

    local overall_success=true

    local scripts_to_run=(
        "backup.sh"
        "packages.sh"
        "tools.sh"
        "environment.sh"
        "symlinks.sh"
    )

    if [[ ${#scripts_to_run[@]} -eq 0 ]]; then
        log_info "No scripts defined for execution."
        log_info "Dotfiles setup finished."
        return
    fi

    for script_name in "${scripts_to_run[@]}"; do
        if ! run_script "$script_name"; then
            overall_success=false
        fi
    done

    if [[ "$overall_success" = true ]]; then
        log_info "Dotfiles setup finished successfully."
    else
        log_error "Dotfiles setup finished with errors."
        exit 1
    fi
}

main "$@"