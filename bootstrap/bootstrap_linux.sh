#!/bin/bash
# Bootstrap a clean Linux environment with dependencies
set -e

APT_PACKAGES=(zsh vim git-core grc ruby gem rake curl silversearcher-ag ruby-dev build-essential)

echo "apt-get requires sudo"
run_cmd sudo apt-get install ${APT_PACKAGES[@]}

echo "updating default shell to zsh"
run_cmd sudo usermod --shell /usr/bin/zsh $USER
