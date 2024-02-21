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
    neovim
    rake
    ripgrep
    ruby
    ruby-dev
    tmux
    tmuxinator
    vim
    zsh
)

run_cmd sudo apt-get update

echo "apt-get install"
run_cmd sudo apt-get install -y ${APT_PACKAGES[@]}

echo "updating default shell to zsh"
run_cmd sudo usermod --shell /usr/bin/zsh $(whoami)
