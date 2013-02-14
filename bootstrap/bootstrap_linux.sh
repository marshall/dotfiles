#!/bin/bash
# Bootstrap a clean Linux environment with dependencies
set -e

APT_PACKAGES=(zsh vim git-core grc ruby gem rake curl)

install_ack() {
    run_cmd sudo apt-get install ack-grep
    run_cmd sudo update-alternatives --install /usr/bin/ack ack /usr/bin/ack-grep 1
}

echo "apt-get requires sudo"
run_cmd sudo apt-get install ${APT_PACKAGES[@]}

echo "updating default shell to zsh"
run_cmd sudo usermod --shell /usr/bin/zsh $USER
install_ack
