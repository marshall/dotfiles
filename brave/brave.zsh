
if [[ "$OS_NAME" = "Darwin" ]]; then
    export BRAVE_NIGHTLY="/Applications/Brave Browser Nightly.app/Contents/MacOS/Brave Browser Nightly"
fi

brave_nightly() {
    "$BRAVE_NIGHTLY" "$@"
}

brave_nightly_clean() {
    tmpdir=$(mktemp -d "/tmp/brave.XXXXXXX")

    brave_nightly --user-data-dir="$tmpdir" "$@"
    if [[ -d "$tmpdir" ]]; then
        rm -rf "$tmpdir"
    fi
}

brave_nightly_dev_wallet() {
    if [[ ! -d dist/brave ]]; then
        echo "No unpacked extension found in $PWD/dist/brave, did you run yarn dev:brave?"
        return 1
    fi

    brave_nightly_clean --load-extension=dist/brave brave://wallet
}
