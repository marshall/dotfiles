#!/bin/zsh

KUBOS_DEV_DIR=$HOME/Code/kubos
CISTACK_NODE=rpi998

run_cmd() {
    echo "$@"
    $@
}

kubos_cistack_flash() {
    kubos_proj=$PWD
    if [[ ! (-f "$kubos_proj/.yotta.json") ]]; then
        echo "$PWD not a Kubos project"
    fi

    kubos_board=$(cat "$PWD/.yotta.json" | jq -r .build.target | sed 's/,\*//')
    bin_name=$(cat "$PWD/module.json" | jq -r .name)
    rel_src_dir=$(cat "$PWD/module.json" | jq -r .bin)

    local_path="$PWD/build/$kubos_board/$rel_src_dir/$bin_name"
    remote_path="/tmp/$bin_name"

    run_cmd scp "$local_path" "kubos@$CISTACK_NODE:$remote_path"
    run_cmd ssh kubos@$CISTACK_NODE /bin/bash --login \
        -c \'python /var/lib/ansible/tests/boardflash.py -f \"$bin_name\" -p /tmp -b $kubos_board\'
}
