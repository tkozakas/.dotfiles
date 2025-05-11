#!/usr/bin/env bash

set -euo pipefail

# Sdkman
if ! command -v sdk &> /dev/null; then
    curl -s https://get.sdkman.io | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Uv
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    source "$HOME/.uv/bin/uv"
fi