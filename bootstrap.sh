#!/bin/bash
# Bootstrap a clean environment with dependencies
set -e

OS=`uname`
run_cmd() {
    printf "\033[0;1;37m-> \033[0;1;34m"
    echo $@
    printf "\033[0m"
    $@
}

case "$OS" in
    Linux) . bootstrap_linux.sh;;
    Darwin) . bootstrap_osx.sh;;
    *) echo "Unknown OS: $OS"; exit 1;;
esac

run_cmd git submodule update --init

echo "gem requires sudo"
run_cmd sudo gem install rake
run_cmd rake

echo "############################################################"
echo "# bootstrap complete. re-login for changes to take effect. #"
echo "############################################################"
