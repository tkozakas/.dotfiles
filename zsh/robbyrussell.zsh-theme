
# Define an array of emojis
emojis=("🐧" "🤖" "👾")

# Seed random generator
RANDOM=$(date +%s)

# Select a random emoji using the correct Zsh array syntax
random_emoji_index=$(( RANDOM % ${#emojis[@]} + 1 ))
random_emoji=${emojis[random_emoji_index]}

PROMPT="%(?:%{$fg_bold[green]%}$random_emoji:%{$fg_bold[red]%}$random_emoji) %{$fg[cyan]%}%c%{$reset_color%}"
PROMPT+=' $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
