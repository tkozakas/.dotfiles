#!/usr/bin/env bash

set -euo pipefail

# Sdkman
echo "Installing Sdkman..."
if ! command -v sdk &> /dev/null; then
    curl -s https://get.sdkman.io | bash
    if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
        source "$HOME/.sdkman/bin/sdkman-init.sh"
    fi
fi

# Uv
echo "Installing Uv..."
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi