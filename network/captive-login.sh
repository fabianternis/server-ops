#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "${DIR}/../config.cfg"

if ping -c 2 -W 2 8.8.8.8 &> /dev/null; then
    exit 0
fi

curl -s -X POST \
     -d "user=${CAPTIVE_USER}" \
     -d "password=${CAPTIVE_PASS}" \
     "${CAPTIVE_GATEWAY}" > /dev/null

if ping -c 2 -W 2 8.8.8.8 &> /dev/null; then
    logger -t "captive-login" "Authentication successful. Egress restored."
else
    logger -t "captive-login" "Authentication failed. Manual intervention required."
fi
