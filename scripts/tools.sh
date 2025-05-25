set -euo pipefail

# Activate zsh
zsh

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
