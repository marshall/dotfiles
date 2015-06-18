#!/bin/zsh

ipaddr() {
    addr_regex="addr:(\\S+)"
    if [[ "$OS_NAME" = "Darwin" ]]; then
        addr_regex="inet (\\S+)"
    fi

    for iface in `ifconfig -l -u`; do
        ipaddr=$(ifconfig $iface | perl -nle "s/$addr_regex/print \$1/e")
        if [[ -z "$ipaddr" ]]; then
            continue;
        fi
        echo "$iface: $ipaddr"
    done
}

scan_subnet() {
    subnet=$1
    port=$2

    echo "=== Scanning $subnet port $port ==="
    nmap -oG - -p $port --open -sV $subnet/24
}

portscan() {
    typeset -A o_subnet
    typeset -A o_port
    o_port=(--port 22)

    zparseopts -D -K -- -subnet:=o_subnet -port:=o_port

    port=$o_port[--port]
    [[ "$1" != "" ]] && port=$1

    subnet=$o_subnet[--subnet]
    [[ "$2" != "" ]] && subnet=$2

    if [[ ! -z $subnet ]]; then
        scan_subnet $subnet $port
        return
    fi

    typeset -A addrs
    addrs=($(ipaddr | grep -E '^(eth|en|wlan|wan)' | sed 's/://'))

    for iface in "${(@k)addrs}"; do
        subnet=$(echo $addrs[$iface]| perl -nle 's/(\d+\.\d+\.\d+)\.\d+/$1.0/g; print')
        scan_subnet $subnet $port | grep -E -v $addrs[$iface]
    done
}
