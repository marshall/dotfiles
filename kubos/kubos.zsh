#!/bin/zsh
autoload -Uz colors && colors

KUBOS_DEV_DIR=$HOME/Code/kubos
KUBOS_VAGRANT_DIR=$HOME/Code/kubos-vagrant
CISTACK_NODE=rpi998

run_cmd() {
    prog=$(basename "$1")

    print -P "%B[%b%F{green}run_cmd%f%B]%b %B$prog" $(print -r -- ${@[2,-1]}) "%b"
    $@
}

pushd_q() {
    pushd "$@" > /dev/null
}

popd_q() {
    popd "$@" > /dev/null
}

check_kubos_proj() {
    if [[ ! (-f "$1/.yotta.json") ]]; then
        print -P "%F{red}Error%f: No Kubos project found at %F{yellow}$1%f"
        return 1
    fi
}

kubos_vg_term() {
    kubos_proj=$1
    kubos_board=$(cat "$kubos_proj/.yotta.json" | jq -r .build.target | sed 's/,\*//')
    baudrate=$(cat "$kubos_proj/build/$kubos_board/yotta_config.json" | jq -r .hardware.console.baudRate)

    run_cmd vagrant ssh -- -t "sudo screen /dev/ttyACM0 $baudrate"
}

kubos_vg() {
    kubos_proj=$PWD
    check_kubos_proj $kubos_proj || return 1

    pushd_q "$KUBOS_VAGRANT_DIR"

    local_code=$HOME/Code
    vagrant_code=/home/vagrant/Code
    reldir=$(python -c "import os.path as p; print p.relpath('$kubos_proj', '$local_code')")
    cmd="$(print -r -- ${(q)@})"

    case "$1" in
    clean|build|link|link-target)
        cmd="kubos $cmd"
        ;;
    flash)
        # FIXME hack for permissions workaround
        cmd="sudo bash -c \"kubos flash\""
        ;;
    ssh)
        run_cmd vagrant ssh -- -t "cd $vagrant_code/$reldir; $SHELL"
        popd_q
        return 0
        ;;
    term)
        kubos_vg_term "$kubos_proj"
        popd_q
        return 0
        ;;
    esac

    run_cmd vagrant ssh -c "cd $vagrant_code/$reldir; $cmd"
    popd_q
}

kubos_cistack_flash() {
    kubos_proj=${1:-$PWD}
    check_kubos_proj $kubos_proj || return 1

    kubos_board=$(cat "$kubos_proj/.yotta.json" | jq -r .build.target | sed 's/,\*//')
    bin_name=$(cat "$kubos_proj/module.json" | jq -r .name)
    rel_src_dir=$(cat "$kubos_proj/module.json" | jq -r .bin)

    local_path="$kubos_proj/build/$kubos_board/$rel_src_dir/$bin_name"
    remote_path="/tmp/$bin_name"

    run_cmd scp "$local_path" "kubos@$CISTACK_NODE:$remote_path"
    run_cmd ssh kubos@$CISTACK_NODE /bin/bash --login \
        -c \'python /var/lib/ansible/tests/boardflash.py -f \"/tmp/$bin_name\" -b $kubos_board\'
}
