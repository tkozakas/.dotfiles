#!/bin/bash
# Script to watch Neovim config directory and reload all Neovim instances on changes

# Path to config directory
CONFIG_DIR="$HOME/.dotfiles/nvim"

# Check if inotifywait is available
if ! command -v inotifywait &> /dev/null; then
  echo "inotifywait not found. Install inotify-tools."
  exit 1
fi

# Watch for changes and send SIGUSR1 to all nvim processes
inotifywait -m -r -e modify,create,delete "$CONFIG_DIR" | while read -r; do
  pkill -USR1 nvim
done