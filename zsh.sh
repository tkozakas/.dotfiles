#!/bin/bash

if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "Cannot determine the operating system."
    exit 1
fi

install_zsh() {
    case "$DISTRO" in
        arch)
            sudo pacman -S --noconfirm zsh
            ;;
        fedora)
            sudo dnf install -y zsh
            ;;
        ubuntu|debian)
            sudo apt update
            sudo apt install -y zsh
            ;;
        *)
            echo "Unsupported distribution: $DISTRO"
            exit 1
            ;;
    esac

    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "oh-my-zsh is already installed."
    fi

    chsh -s $(which zsh)

    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [ -f "$SCRIPT_DIR/.zshrc" ]; then
        cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
        echo "Copied .zshrc to $HOME/.zshrc"
    else
        echo "No .zshrc file found in the script directory."
    fi
}

install_zsh

echo "Installation complete! Please restart your terminal or source ~/.zshrc to start using Zsh."
