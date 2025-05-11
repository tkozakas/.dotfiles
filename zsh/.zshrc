if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ ! -d "${ZPLUG_HOME:-$HOME/.zplug}" ]]; then
    git clone https://github.com/zplug/zplug "${ZPLUG_HOME:-$HOME/.zplug}"
fi
source "${ZPLUG_HOME:-$HOME/.zplug}/init.zsh"

zplug "romkatv/powerlevel10k", as:theme, depth:1

zplug "plugins/git", from:ohmyzsh
zplug "plugins/dirhistory", from:ohmyzsh
zplug "plugins/z", from:ohmyzsh

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

if command -v fzf &> /dev/null; then
    _fzf_key_bindings_path=""
    _fzf_completion_path=""
    if [[ -s "$(fzf --zsh-path key-bindings 2>/dev/null)" ]]; then
        _fzf_key_bindings_path="$(fzf --zsh-path key-bindings)"
    elif [[ -s "/usr/share/fzf/shell/key-bindings.zsh" ]]; then
        _fzf_key_bindings_path="/usr/share/fzf/shell/key-bindings.zsh"
    fi
    if [[ -s "$(fzf --zsh-path completion 2>/dev/null)" ]]; then
        _fzf_completion_path="$(fzf --zsh-path completion)"
    elif [[ -s "/usr/share/fzf/shell/completion.zsh" ]]; then
        _fzf_completion_path="/usr/share/fzf/shell/completion.zsh"
    fi
    [[ -n "$_fzf_key_bindings_path" && -s "$_fzf_key_bindings_path" ]] && source "$_fzf_key_bindings_path"
    [[ -n "$_fzf_completion_path" && -s "$_fzf_completion_path" ]] && source "$_fzf_completion_path"
fi

if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh --cmd cd)"
fi

if command -v direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

if [[ -f ~/.zshaliases ]]; then
    source ~/.zshaliases
fi

export FZF_DEFAULT_OPTS='--height 30% --layout=reverse --border=none'
export HSA_OVERRIDE_GFX_VERSION=10.3.0

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh