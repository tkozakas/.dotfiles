#!/bin/zsh

killall -9 waybar

hyprctl reload
waybar &

