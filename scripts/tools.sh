#!/usr/bin/env bash

set -euo pipefail

# Sdkman
if ! command -v sdk &> /dev/null; then
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Uv
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# Docker
if ! command -v docker &> /dev/null; then
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case "$ID" in
            arch)
                sudo pacman -Syu --noconfirm --needed docker
                ;;
            fedora)
                sudo dnf install -y moby-engine
                ;;
            ubuntu|debian)
                sudo apt update && sudo apt install -y docker.io
                ;;
        esac
    fi
fi

# Docker Compose
if ! (docker compose version &> /dev/null) && ! (command -v docker-compose &> /dev/null); then
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case "$ID" in
            arch)
                sudo pacman -Syu --noconfirm --needed docker-compose
                ;;
            fedora)
                sudo dnf install -y docker-compose
                ;;
            ubuntu|debian)
                sudo apt update && (sudo apt install -y docker-compose-v2 || sudo apt install -y docker-compose)
                ;;
        esac
    fi
fi
