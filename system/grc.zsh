# GRC colorizes nifty unix tools all over the place
if $(grc &>/dev/null)
then
  if [[ "`uname`" = "Darwin" ]]; then
    source `brew --prefix`/etc/grc.(zsh|bashrc)
  fi

  # grc overides for ls
  #   Made possible through contributions from generous benefactors like
  #   `brew install coreutils`
  if $(gls &>/dev/null)
  then
    alias ls="gls -F --color"
    alias l="gls -lAh --color"
    alias ll="gls -l --color"
    alias la='gls -A --color'
  fi
fi
