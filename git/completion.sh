if ( which brew >/dev/null ); then
  zstyle ':completion:*:*:git:*' script $(brew --prefix)/etc/bash_completion.d/git-completion.bash
elif [[ -f /usr/share/bash-completion/completions/git ]]; then
  zstyle ':completion:*:*:git:*' script /usr/share/bash-completion/completions/git
fi
