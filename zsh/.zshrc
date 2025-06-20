if [[ -f ~/.zshalias ]]; then
    source ~/.zshalias
fi

if [[ -f ~/.zshenv ]]; then
    source ~/.zshenv
fi
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ ! -d "${ZPLUG_HOME:-$HOME/.zplug}" ]]; then
    git clone https://github.com/zplug/zplug "${ZPLUG_HOME:-$HOME/.zplug}"
fi

source "${ZPLUG_HOME:-$HOME/.zplug}/init.zsh"

zplug "romkatv/powerlevel10k", as:theme, depth:1

zplug "ohmyzsh/ohmyzsh", use:"plugins/git"
zplug "ohmyzsh/ohmyzsh", use:"plugins/z"

zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "zsh-users/zsh-completions", defer:2 
zplug "zsh-users/zsh-history-substring-search", defer:2

if ! zplug check; then
    zplug install
fi

zplug load

autoload -Uz compinit
compinit -i

. "$HOME/.local/bin/env"
