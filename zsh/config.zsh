export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

fpath=($ZSH/zsh/functions $fpath)

if [ -d $ZSH/zsh/functions ]; then
    autoload -U $ZSH/zsh/functions/*(:t)
fi

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# please don't confirm
setopt rmstarsilent

# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
setopt complete_aliases

# allow function / var substitution in $PROMPT
setopt prompt_subst

zle -N newtab

bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[5D' beginning-of-line
bindkey '^[[5C' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[^N' newtab
bindkey '^?' backward-delete-char
