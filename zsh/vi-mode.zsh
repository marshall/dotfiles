function zle-keymap-select {
  zle reset-prompt
}

function zle-line-init {
  zle vi-end-of-line
  zle reset-prompt
}

function vi-up-line-or-history {
  zle .vi-up-line-or-history
  zle vi-end-of-line
}

zle -N zle-line-init
zle -N zle-keymap-select
zle -N vi-up-line-or-history

bindkey -v

# if mode indicator wasn't setup by theme, define default
if [[ "$MODE_INDICATOR" == "" ]]; then
  MODE_INDICATOR="%{$fg_bold[red]%}<%{$fg[red]%}<<%{$reset_color%}"
fi

function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/}"
}

# define right prompt, if it wasn't defined by a theme
if [[ "$RPS1" == "" && "$RPROMPT" == "" ]]; then
  RPS1='$(vi_mode_prompt_info)'
fi
