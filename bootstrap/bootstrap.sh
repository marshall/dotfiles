#!/bin/bash
# Bootstrap a clean environment with dependencies
set -e

RUBY_GEMS=(rake redcarpet pygments.rb tty-progressbar pastel)

THIS_DIR=$(
    cd $(dirname "$0")
    pwd
)
OS=$(uname)

run_cmd() {
    printf "\033[0;1;37m-> \033[0;1;34m"
    echo $@
    printf "\033[0m"
    $@
}

case "$OS" in
Linux) . $THIS_DIR/bootstrap_linux.sh ;;
Darwin) . $THIS_DIR/bootstrap_osx.sh ;;
MINGW64*)
    # wholesale environment switch for MINGW64
    exec $THIS_DIR/bootstrap_mingw.sh
    ;;
*)
    echo "Unknown OS: $OS"
    exit 1
    ;;
esac

run_cmd git submodule update --init --recursive

echo "gem requires sudo"
run_cmd gem install ${RUBY_GEMS[@]}
run_cmd rake

echo "install zoxide"
run_cmd curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

echo "############################################################"
echo "# bootstrap complete. re-login for changes to take effect. #"
echo "############################################################"
