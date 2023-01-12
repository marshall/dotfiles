if ( which brew >/dev/null ); then
  # NODE_PATH for npm / node installed via brew
  DEFAULT_NODE_PATH=$(nvm which current | sed "s/bin\/node/lib\/node_modules/")
  export NODE_PATH=$(/usr/bin/env npm root -g 2>/dev/null || echo "$DEFAULT_NODE_PATH")
fi
