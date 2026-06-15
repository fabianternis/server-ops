#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "${DIR}/../config.cfg"

if ping -c 3 -W 3 "${WG_PEER_IP}" &> /dev/null; then
    exit 0
fi

logger -t "wg-keepalive" "Handshake failure with external peer. Resetting interface ${WG_INTERFACE}."

/usr/bin/systemctl restart wg-quick@${WG_INTERFACE}
