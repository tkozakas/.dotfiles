export EDITOR='nvim'
export VISUAL="$EDITOR"

if [[ -f "${DOTFILES_DIR:-$HOME/.dotfiles}/config/environment.conf" ]]; then
    source "${DOTFILES_DIR:-$HOME/.dotfiles}/config/environment.conf"
fi