export MNML_USER_CHAR=$(emojis=('🫠' '🫣' '🥴' '🤡' '🥺' '🤓' '🤠' '👽' '👻' '💩' '🦞' '🦥' '🦖' '🗿' '🪑'); print -r -- "${emojis[$(( (RANDOM % ${#emojis[@]}) + 1 ))]}")
export EDITOR='nvim'
export VISUAL="$EDITOR"

export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=20000

setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

export FZF_DEFAULT_OPTS='--height 40% --tmux bottom,40% --layout reverse --border=none'
