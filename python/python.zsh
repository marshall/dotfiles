_path_prepend "$HOME/.local/bin"

# Loads at startup for the python REPL
export PYTHONSTARTUP=$ZSH/python/pythonrc.py

# Point iPython to this directory for it's config
export IPYTHON_DIR=$ZSH/python

# virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUAL_ENV_DISABLE_PROMPT=1
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
if [[ -e /usr/local/bin/python3 ]]; then
    export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
fi

if ( which python3 >/dev/null ); then
    _path_prepend "`python3 -msite --user-base`/bin"
fi

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi
#if [[ -f /usr/local/bin/virtualenvwrapper.sh ]]; then
#  source /usr/local/bin/virtualenvwrapper.sh
#elif [[ -f /etc/bash_completion.d/virtualenvwrapper ]]; then
#  source /etc/bash_completion.d/virtualenvwrapper
#fi
