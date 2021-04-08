#!/bin/bash
# Bootstrap a clean Linux environment with dependencies
set -e

APT_PACKAGES=(zsh vim git-core grc ruby gem rake curl silversearcher-ag ruby-dev build-essential)
BREW_PACKAGES=(fzf ripgrep tmux tmuxinator bat)

echo "apt-get requires sudo"
run_cmd sudo apt-get install ${APT_PACKAGES[@]}

echo "updating default shell to zsh"
run_cmd sudo usermod --shell /usr/bin/zsh $USER

install_brew() {
    echo "brew requires sudo"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
}

which brew 2>/dev/null || install_brew
run_cmd brew install ${BREW_PACKAGES[@]}
