#!/usr/bin/env bash

set -euo pipefail

_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "${_SCRIPT_DIR}/common.sh"

ENV_CONFIG_FILE="${DOTFILES_DIR}/config/environment.conf"
GENERATED_ENV_FILE_HOME="${HOME}/.general_env.sh"
ZSHENV_DOTFILE_PATH="${DOTFILES_DIR}/zsh/.zshenv"

ensure_sourcing_line() {
    local file_to_modify="$1"
    local line_to_ensure="$2"
    local marker_text="# Added by Dotfiles Environment Module"

    if [[ ! -f "$file_to_modify" ]]; then
        log_error "File to modify for sourcing not found: $file_to_modify."
        return 1
    fi

    local escaped_line
    escaped_line=$(sed 's/[^^]/[&]/g; s/\^/\\^/g' <<< "$line_to_ensure")

    if ! grep -qFx -- "$escaped_line" "$file_to_modify"; then
        printf "\n%s\n%s\n" "$marker_text" "$line_to_ensure" >> "$file_to_modify"
    fi
    return 0
}

main() {
    if [[ ! -f "$ENV_CONFIG_FILE" ]]; then
        log_error "Environment config file not found: $ENV_CONFIG_FILE. Skipping."
        return 1
    fi

    cp "$ENV_CONFIG_FILE" "$GENERATED_ENV_FILE_HOME"
    chmod 600 "$GENERATED_ENV_FILE_HOME"

    local sourcing_line="[[ -f \"${GENERATED_ENV_FILE_HOME}\" ]] && source \"${GENERATED_ENV_FILE_HOME}\""

    if ! ensure_sourcing_line "$ZSHENV_DOTFILE_PATH" "$sourcing_line"; then
        return 1
    fi

    return 0
}

main