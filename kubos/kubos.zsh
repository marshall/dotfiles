#!/bin/zsh 
KUBOS_DEV_DIR=$HOME/Code/kubos
CISTACK_NODE=rpi998

run_cmd() {
    echo "$@"
    $@
}

kubos_cistack_flash() {
    kubos_proj=${1:-$PWD}

    if [[ ! (-f "$kubos_proj/.yotta.json") ]]; then
        echo "$kubos_proj not a Kubos project"
    fi

    kubos_board=$(cat "$kubos_proj/.yotta.json" | jq -r .build.target | sed 's/,\*//')
    bin_name=$(cat "$kubos_proj/module.json" | jq -r .name)
    rel_src_dir=$(cat "$kubos_proj/module.json" | jq -r .bin)

    local_path="$kubos_proj/build/$kubos_board/$rel_src_dir/$bin_name"
    remote_path="/tmp/$bin_name"

    run_cmd scp "$local_path" "kubos@$CISTACK_NODE:$remote_path"
    run_cmd ssh kubos@$CISTACK_NODE /bin/bash --login \
        -c \'python /var/lib/ansible/tests/boardflash.py -f \"/tmp/$bin_name\" -b $kubos_board\'
}
