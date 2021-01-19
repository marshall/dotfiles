BRAVE_RAMDISK_ENABLED=0
BRAVE_RAMDISK_SIZE_GB=256
BRAVE_RAMDISK_VOLUME_NAME=RamDisk
BRAVE_RAMDISK=/Volumes/$BRAVE_RAMDISK_VOLUME_NAME
BRAVE_DEV_DIR=$HOME/Code/brave
BRAVE_PROFILES_DIR=$HOME/Test/profiles

export SCCACHE_CACHE_SIZE=100G
export SCCACHE_DIR=$HOME/sccache

if [[ "$OS_NAME" = "Darwin" ]]; then
    BRAVE_RAMDISK_ENABLED=$((`hostinfo | grep 'Primary memory available' | sed 's/[a-zA-Z ]*: //' | sed 's/ gigabytes//'` > 128))
    export BRAVE_NIGHTLY="/Applications/Brave Browser Nightly.app/Contents/MacOS/Brave Browser Nightly"
    if [[ "$BRAVE_RAMDISK_ENABLED" = "1" ]]; then
        export SCCACHE_DIR=$BRAVE_RAMDISK/sccache
    fi
elif [[ "$OS_NAME" = "Linux" ]]; then
    export BRAVE_NIGHTLY=/usr/bin/brave-browser-nightly
fi

brave_dev_bin() {
    brave_repo=${BRAVE_REPO:-$BRAVE_DEV_DIR/brave-browser}
    brave_build_type=${1:-${BRAVE_BUILD_TYPE:-Component}}

    build_dir=$brave_repo/src/out/$brave_build_type

    if [[ "$OS_NAME" = "Darwin" ]]; then
        echo "$build_dir/Brave Browser Development.app/Contents/MacOS/Brave Browser Development"
    elif [[ "$OS_NAME" = "Linux" ]]; then
        echo "$build_dir/brave"
    fi
}

brave_profile() {
    brave_bin=$1
    shift

    if [ ! -x "$brave_bin" ]; then
        echo "Invalid Brave binary: $brave_bin"
        return 1
    fi

    profile=$1
    shift

    if [ -z "$profile" ]; then
        echo "Missing profile dir"
        return 1
    fi

    "$brave_bin" --user-data-dir="$profile" "$@"
}

brave_tmp_profile() {
    brave_bin=$1
    shift

    if [ ! -x "$brave_bin" ]; then
        echo "Invalid Brave binary: $brave_bin"
        return 1
    fi

    tmpdir=$(mktemp -d "/tmp/brave.XXXXXXX")
    brave_profile "$brave_bin" "$tmpdir" "$@"

    if [[ -d "$tmpdir" ]]; then
        rm -rf "$tmpdir"
    fi
}

brave_dev() {
    npm start "$@"
}

brave_dev_clean() {
    brave_tmp_profile brave_dev
}

brave_dev_dev_wallet() {
    brave_bin=$(brave_dev_bin)
    if [[ ! -x "$brave_bin" ]]; then
        echo "No build of brave found at $brave_bin"
        return 1
    fi

    erc=${1:-$BRAVE_DEV_DIR/ethereum-remote-client}
    profile=${2:-$BRAVE_PROFILES_DIR/dev-wallet}
    if [[ ! -d "$erc/dist/brave" ]]; then
        echo "No unpacked extension found in $erc/dist/brave, did you run yarn dev:brave?"
        return 1
    fi

    brave_profile "$brave_bin" "$profile" --load-extension="$erc/dist/brave"
}

brave_nightly() {
    "$BRAVE_NIGHTLY" "$@"
}

brave_nightly_clean() {
    brave_tmp_profile "$BRAVE_NIGHTLY" "$@"
}

brave_nightly_dev_wallet() {
    profile=${1:-$BRAVE_PROFILES_DIR/dev-wallet}
    erc=$PWD

    if [[ ! -d "$erc/dist/brave" ]]; then
        erc=$BRAVE_DEV_DIR/ethereum-remote-client
        if [[ ! -d "$erc/dist/brave" ]]; then
            echo "No unpacked extension found in $erc/dist/brave, did you run yarn dev:brave?"
            return 1
        fi
    fi

    brave_profile "$BRAVE_NIGHTLY" "$profile" --load-extension="$erc/dist/brave"
}

brave_ramdisk_create() {
    if [[ "$OS_NAME" != "Darwin" ]]; then
        echo "Brave RAM disk only supported in macOS"
        return
    fi

    if [[ ! -d $BRAVE_RAMDISK ]]; then
        diskutil erasevolume HFS+ $BRAVE_RAMDISK_VOLUME_NAME \
            `hdiutil attach -nobrowse -nomount ram://$(($BRAVE_RAMDISK_SIZE_GB * 1024 * 2048))`
    fi
}

brave_ramdisk_init() {
    brave_ramdisk_create
    rsync -a --info=progress2 $HOME/Code/brave/brave-browser $BRAVE_RAMDISK
}

brave_browser_tests_impl() {
    npm run test -- brave_browser_tests "$@"
}

alias brave_browser_tests="noglob brave_browser_tests_impl"

extract_json() {
    i=0
    while read line; do
        json_pre=${line%*\{}
        json=${line#*\{}
        json=${json%\}\"*}
        formatted=$(echo "{$json}" | jq -c . 2>/dev/null || echo "$line")
        printf "%s\n" "$formatted"
        i=$(( i + 1 ))
    done
}
