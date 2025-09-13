set -euo pipefail
chsh -s $(which zsh)

# fzf
[ -d "${HOME}/.fzf/.git" ] || (echo "Installing fzf…" && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all)

# yay
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
yay --save --nocleanmenu --nodiffmenu
# yay stuff TODO move it to packages.conf with yay tag
yay -S matugen-bin

# Sdkman
echo "Installing Sdkman..."
if ! command -v sdk &>/dev/null; then
  curl -s https://get.sdkman.io | bash
fi

# Uv
echo "Installing Uv..."
if ! command -v uv &>/dev/null; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
