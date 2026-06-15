#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "${DIR}/../config.cfg"

# If the WireGuard peer is reachable, everything is fine.
if ping -c 3 -W 3 "${WG_PEER_IP}" &> /dev/null; then
    exit 0
fi

# To avoid false-positive restarts when the host's physical network is down,
# verify that we can reach either the default gateway or a public server.
# Gateway is usually 172.19.0.1 on this network.
local_gateway="172.19.0.1"
if ! ping -c 2 -W 2 "${local_gateway}" &> /dev/null && ! ping -c 2 -W 2 8.8.8.8 &> /dev/null; then
    logger -t "wg-keepalive" "Physical connection or gateway is down. Skipping WireGuard interface reset."
    exit 0
fi

logger -t "wg-keepalive" "WireGuard peer ${WG_PEER_IP} is down while host has internet. Resetting interface ${WG_INTERFACE}."

/usr/bin/systemctl restart wg-quick@${WG_INTERFACE}

