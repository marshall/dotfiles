# Add Visual Studio Code (code)

VSCODE_APP="/Applications/Visual Studio Code.app"
VSCODE_BIN="$VSCODE_APP/Content/Resources/app/bin"

_path_append "$VSCODE_BIN"

if [[ -x "$VSCODE_BIN/code" ]]; then
    export VISUAL="code --wait --reuse-window"
fi
