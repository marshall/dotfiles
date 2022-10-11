# explicitly set COLORTERM in some situations for better color detection in some tools

if [[ ! -z "$WSL_DISTRO_NAME" || "$TERM" = "xterm-256color" ]]; then
    export COLORTERM=truecolor
fi
