set -euo pipefail
chsh -s $(which zsh)

# fzf
[ -d "${HOME}/.fzf/.git" ] || (echo "Installing fzf…" && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all)

# yay
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
# yay stuff TODO move it to packages.conf with yay tag
yay -S matugen-bin
