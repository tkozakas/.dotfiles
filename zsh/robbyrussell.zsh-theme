# funny prompts
# Define an array of emojis
emojis=("🐧" "🤖" "👾")

# Seed random generator
RANDOM=$(date +%s)

# Select a random emoji using the correct Zsh array syntax
random_emoji_index=$(( $RANDOM % ${#emojis[@]} + 1 ))
random_emoji=${emojis[$random_emoji_index]}

PROMPT="%F{yellow}$random_emoji%f  %F{blue}%~%f "

PROMPT="%(?:%{$fg_bold[green]%}%F{yellow}$random_emoji%f :%{$fg_bold[red]%}➜ ) %{$fg[cyan]%}%c%{$reset_color%}"
PROMPT+=' $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
