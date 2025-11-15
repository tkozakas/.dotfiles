#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$({
        find "$HOME/Documents" -mindepth 1 -maxdepth 1 -type d
        echo "$HOME/.dotfiles"
    } | fzf --select-1 --exit-0)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | sed 's/^\.//')

if tmux list-windows -a -F '#{window_name}' | grep -q "^${selected_name}$"; then
    CURRENT_WINDOW_NAME=$(tmux display-message -p '#{window_name}')

    if [ "$selected_name" = "$CURRENT_WINDOW_NAME" ]; then
        exit 0
    else
        tmux select-window -t "$selected_name"
    fi
else
    tmux new-window -n "$selected_name" -c "$selected"
    tmux send-keys -t "$selected_name" "nvim ." C-m
fi
