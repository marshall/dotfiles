#!/bin/bash
# Bootstrap a clean environment with dependencies
set -e

PIP_PACKAGES=(virtualenv virtualenvwrapper)
RUBY_GEMS=(rake redcarpet pygments.rb)
NPM_PACKAGES=(instant-markdown-d)

THIS_DIR=$(cd `dirname "$0"`; pwd)
OS=`uname`

run_cmd() {
    printf "\033[0;1;37m-> \033[0;1;34m"
    echo $@
    printf "\033[0m"
    $@
}

case "$OS" in
    Linux) . $THIS_DIR/bootstrap_linux.sh;;
    Darwin) . $THIS_DIR/bootstrap_osx.sh;;
    *) echo "Unknown OS: $OS"; exit 1;;
esac

run_cmd git submodule update --init --recursive

echo "pip requires sudo"
run_cmd curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
run_cmd sudo python /tmp/get-pip.py

echo "virtualenv and virtualenvwrapper require sudo"
PIP_ARGS=
if [[ "$OS" = "Darwin" ]]; then
    PIP_ARGS="--ignore-installed six"
fi
run_cmd sudo pip install $PIP_ARGS ${PIP_PACKAGES[@]}

echo "npm requires sudo"
run_cmd sudo npm -g install ${NPM_PACKAGES[@]}

echo "gem requires sudo"
run_cmd sudo gem install ${RUBY_GEMS[@]}
run_cmd rake

echo "############################################################"
echo "# bootstrap complete. re-login for changes to take effect. #"
echo "############################################################"
