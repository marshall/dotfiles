#!/bin/bash
# Bootstrap a clean Linux environment with dependencies
set -e

APT_PACKAGES=(
  bat
  build-essential
  curl
  fzf
  gem 
  git-core
  grc
  rake
  ripgrep
  ruby
  ruby-dev
  tmux
  tmuxinator
  vim
  neovim
  zsh
)

echo "apt-get requires sudo"
run_cmd sudo apt-get install ${APT_PACKAGES[@]}

echo "updating default shell to zsh"
run_cmd sudo usermod --shell /usr/bin/zsh $USER
