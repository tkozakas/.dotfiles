#!/bin/bash

function pacmanInstall() {
  sudo pacman -S "${@}" --noconfirm --needed
}

# check if paru is installed
if ! hash paru 2>/dev/null; then
  git clone https://aur.archlinux.org/paru-bin.git "/home/${USER}/paru-bin"
  cd "/home/${USER}/paru-bin" || exit
  makepkg -si --noconfirm --needed
  rm -rf "/home/${USER}/paru-bin"
fi

function paruInstall() {
  paru -S "${@}" --noconfirm --needed
}

# prerequisites
pacmanInstall stow git wl-clipboard xclip libnewt glib2
# just in case someone decides to copy it to the wrong directory
[[ ! -d ~/.dotfiles ]] && git clone https://github.com/tomas6446/.dotfiles ~/.dotfiles 
cd ~/.dotfiles || exit
git submodule init && git submodule update

# mangohud
# flatpak steam doesnt work if mangohud config is a symlink so just copy it manually
mkdir -pv ~/.config/MangoHud && cp ~/.dotfiles/mangohud/.config/MangoHud/MangoHud.conf ~/.config/MangoHud

#gnome
bash gnome/install_extension.sh

# gtk
stow gnome/gtk3 gnome/gtk4
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
