#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "${DIR}/../config.cfg"

# Verify internet access by checking HTTP status from a known connectivity check endpoint.
# A 204 response indicates active Internet connection.
check_internet() {
    local status
    status=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 http://connectivitycheck.gstatic.com/generate_204 || echo "000")
    if [ "${status}" -eq 204 ]; then
        return 0
    else
        return 1
    fi
}

if check_internet; then
    exit 0
fi

logger -t "captive-login" "Egress blocked. Attempting captive portal authentication..."

curl -s -X POST \
     -d "user=${CAPTIVE_USER}" \
     -d "password=${CAPTIVE_PASS}" \
     "${CAPTIVE_GATEWAY}" > /dev/null

# Give interface a moment to update routing state
sleep 2

if check_internet; then
    logger -t "captive-login" "Authentication successful. Egress restored."
else
    logger -t "captive-login" "Authentication failed. Manual intervention required."
fi

