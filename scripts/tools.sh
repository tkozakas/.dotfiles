set -euo pipefail
chsh -s $(which zsh)

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion

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
