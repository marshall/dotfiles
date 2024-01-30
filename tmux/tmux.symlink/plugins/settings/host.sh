#!/bin/zsh

this_dir=$(cd "`dirname "$0"`"; pwd)
prefix=$([ "$P9K_SSH" = "1" ] && echo "" || echo "")
echo "$prefix $(hostname -s)"
