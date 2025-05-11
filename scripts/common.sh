#!/usr/bin/env bash

set -euo pipefail

_COMMON_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "${_COMMON_SCRIPT_DIR}/.." && pwd)"

LOG_FILE="${DOTFILES_DIR}/setup.log"

_log_base() {
    local type="$1"
    local message="$2"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp][$type] $message" | tee -a "$LOG_FILE"
}

log_info() {
    _log_base "INFO" "$1"
}

log_warn() {
    _log_base "WARN" "$1"
}

log_error() {
    _log_base "ERROR" "$1" >&2
}

touch "$LOG_FILE"
chmod 600 "$LOG_FILE"