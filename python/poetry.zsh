_path_prepend "$HOME/.local/bin"

if ( which poetry >/dev/null ); then
  if [[ ! -d "$HOME/.zfunc" ]]; then
    mkdir "$HOME/.zfunc"
  fi
  if [[ ! -f "$HOME/.zfunc/_poetry" ]]; then
    poetry completions zsh > ~/.zfunc/_poetry
  fi
fi

fpath+=$HOME/.zfunc
