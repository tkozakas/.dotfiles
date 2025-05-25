set -euo pipefail

_COMMON_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC2034
DOTFILES_DIR="$(cd "${_COMMON_SCRIPT_DIR}/.." && pwd)"

_log_base() {
  local type="$1"
  local message="$2"
  local timestamp
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo "[$timestamp][$type] $message"
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
