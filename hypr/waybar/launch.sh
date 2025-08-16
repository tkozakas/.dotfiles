#!/bin/bash

DEFAULT_DIR="$HOME/.config/waybar"
DOTFILES_DIR="$HOME/.dotfiles/hypr/waybar"

killall -q waybar
while pgrep -x waybar >/dev/null; do sleep 1; done

if [ ! -L "$DEFAULT_DIR" ]; then
  if [ -e "$DEFAULT_DIR" ]; then
    echo "Backing up existing $DEFAULT_DIR to ${DEFAULT_DIR}.bak"
    mv "$DEFAULT_DIR" "${DEFAULT_DIR}.bak"
  fi
  echo "Creating symlink for Waybar..."
  ln -s "$DOTFILES_DIR" "$DEFAULT_DIR"
fi

waybar &
