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

# some apps to install
pacmanInstall github-cli zsh steam discord telegram firefox
paruInstall jetbrains-toolbox

# pin them here
gsettings set org.gnome.shell favorite-apps ['org.gnome.Nautilus.desktop', 'org.gnome.Console.desktop', 'firefox.desktop', 'org.telegram.desktop.desktop', 'steam.desktop', 'jetbrains-toolbox.desktop']

# oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# add the button layout if not added by the sila script
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"