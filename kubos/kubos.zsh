#!/bin/zsh
autoload -Uz colors && colors

KUBOS_DEV_DIR=$HOME/Code/kubos
KUBOS_VAGRANT_DIR=$HOME/Code/kubos-vagrant
CI_STM32F4_NODE=rpi1
CI_MSP430_NODE=rpi2
CI_PYBOARD_NODE=rpi3

run_cmd() {
    prog=$(basename "$1")

    print -P "%B[%b%F{green}run_cmd%f%B]%b %BIn $PWD%b"
    print -P "%B[%b%F{green}run_cmd%f%B]%b %B  % $prog" $(print -r -- ${@[2,-1]}) "%b"
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

kubos_proj_reldir() {
    kubos_proj=$1
    local_code=$HOME/Code
    vagrant_code=/home/vagrant/Code
    reldir=$(python -c "import os.path as p; print p.relpath('$kubos_proj', '$local_code')")
    echo "$vagrant_code/$reldir"
}

kubos_proj_board() {
    cat "$1/.yotta.json" | jq -r .build.target | sed 's/,\*//'
}

kubos_proj_config() {
    kubos_proj=$1
    q=$2
    kubos_board=$(kubos_proj_board "$kubos_proj")
    cat "$kubos_proj/build/$kubos_board/yotta_config.json" | jq -r "$q"
}

kubos_console_uart() {
    kubos_proj_config "$1" .hardware.console.uart
}

kubos_console_baudrate() {
    kubos_proj_config "$1" .hardware.console.baudRate
}

kubos_console_linux_dev() {
    kubos_proj=$1
    board=$(kubos_proj_board "$kubos_proj")
    uart=$(kubos_console_uart "$kubos_proj")
    case "$board" in
    msp430*)
        case "$uart" in
        K_UART1)
            echo /dev/ttyUSB0 ;;
        K_UART2|*)
            echo /dev/ttyACM1 ;;
        esac
        ;;
    stm32f4*|*)
        echo /dev/ttyUSB0 ;;
    esac
}

kubos_vg_console() {
    kubos_proj=$1
    dev=${2:-$(kubos_console_linux_dev "$kubos_proj")}

    baudrate=$(kubos_console_baudrate "$1")
    run_cmd vagrant ssh -- -t "sudo screen $dev $baudrate"
}

kubos_vg() {
    kubos_proj=$PWD
    pushd_q "$KUBOS_VAGRANT_DIR"

    cmd="$(print -r -- ${(q)@})"

    # non-kubos project pass through commands
    case "$1" in
    box|connect|destroy|global-status|halt|init|package|plugin|port|provision|push|rdp|reload|resume|share|snapshot|ssh-config|status|suspend|up)
        # vagrant pass-through commands
        run_cmd vagrant $1
        popd_q
        return 0
        ;;
    ssh)
        ssh_pre=
        if (( check_kubos_proj $kubos_proj )); then
            ssh_pre="cd $(kubos_proj_reldir $kubos_proj);"
        fi

        run_cmd vagrant ssh -- -t "$ssh_pre $SHELL"
        popd_q
        return 0
        ;;
    esac

    check_kubos_proj $kubos_proj || return 1
    cwd=$(kubos_proj_reldir $kubos_proj)

    case "$1" in
    clean|build|link|link-target|target|config)
        cmd="kubos $cmd"
        ;;
    flash|start)
        # FIXME hack for permissions workaround
        cmd="sudo bash -c \"kubos flash\""
        ;;
    console|term)
        kubos_vg_console "$kubos_proj" "$2"
        popd_q
        return 0
        ;;
    esac

    run_cmd vagrant ssh -c "cd $cwd; $cmd"
    popd_q
}

ci_node() {
    board=$1
    case "$board" in
    msp430*)
        echo $CI_MSP430_NODE
        ;;
    stm32f4*)
        echo $CI_STM32F4_NODE
        ;;
    pyboard*)
        echo $CI_PYBOARD_NODE
        ;;
    esac
}

kubos_ci() {
    ci_cmd=$1
    kubos_proj=${2:-$PWD}
    check_kubos_proj $kubos_proj || return 1

    kubos_board=$(kubos_proj_board "$kubos_proj")
    bin_name=$(cat "$kubos_proj/module.json" | jq -r .name)
    rel_src_dir=$(cat "$kubos_proj/module.json" | jq -r .bin)

    local_path="$kubos_proj/build/$kubos_board/$rel_src_dir/$bin_name"
    if [[ "$kubos_board" = "pyboard-gcc" ]]; then
        # pyboard needs a .bin file
        local_path="$local_path.bin"
    fi

    remote_path="/tmp/$bin_name"
    node=$(ci_node "$kubos_board")

    case "$ci_cmd" in
    flash)
        run_cmd scp "$local_path" "$node:$remote_path"
        run_cmd ssh $node /bin/bash --login \
            -c \'python /var/lib/ansible/tests/boardflash.py -f \"$remote_path\" -b $kubos_board\'
        ;;
    console|term)
        baudrate=$(kubos_console_baudrate "$kubos_proj")
        dev=$(kubos_console_linux_dev "$kubos_proj")
        run_cmd ssh -t $node screen $dev $baudrate
        ;;
    esac

}
