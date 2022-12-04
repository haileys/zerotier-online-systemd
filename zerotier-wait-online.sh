#!/bin/bash
set -euo pipefail

err() {
    /usr/bin/printf "%s\n" "$1" >&2
}

die() {
    err "$1"
    exit 1
}

usage() {
    die "usage: zerotier-wait-online <network id or network name>"
}

jq_network_status() {
    local network="$1"

    /usr/bin/jq --raw-output \
	    --arg network "$network" \
	    '.[] | [select(.nwid == $network), select(.name == $network)] | .[0].status'
}

network_online() {
    local network="$1"
    shift

    local status="$(/usr/bin/zerotier-cli -j listnetworks | jq_network_status "$network")" || return 0
    [[ "$status" == "OK" ]]
}

[ "$#" -ge 1 ] || usage
NETWORK="$1"

declare -a DELAYS=(0 0 0 1 1 1 3 3 3 5 5 5 10 10 10)
DELAY_IDX=0
MAX_DELAY=10

while true; do
    if network_online "$NETWORK"; then
        exit 0
    fi

    if [ "$DELAY_IDX" -ge "${#DELAYS[@]}" ]; then
        die "$NETWORK: failed to come online, giving up"
    fi

    ITER_DELAY="${DELAYS[$DELAY_IDX]}"
    err "$NETWORK: trying again in ${ITER_DELAY}s"
    /usr/bin/sleep "$ITER_DELAY"
    DELAY_IDX="$(($DELAY_IDX + 1))"
done
