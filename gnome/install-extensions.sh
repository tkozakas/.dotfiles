#!/bin/sh

set -e -u -x

if ! type gnome-extensions-cli; then
    pipx install gnome-extensions-cli
    pipx runpip gnome-extensions-cli install pygobject
fi

install_extension () {
    gnome-extensions-cli install "$1"
}

#install_extension 
install_extension arcmenu@arcmenu.com
install_extension bluetooth-quick-connect@bjarosze.gnam.com
install_extension dash-to-panel@jderose9.github.com
install_extension upower-battery@codilia.com