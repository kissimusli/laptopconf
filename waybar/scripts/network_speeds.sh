#!/usr/bin/env bash

INTERFACE="wlo1"

# Exit early if interface doesn't exist
if [[ ! -d "/sys/class/net/$INTERFACE" ]]; then
    echo '{"text": ""}'
    exit 0
fi

# Check if interface is up
OPERSTATE_FILE="/sys/class/net/$INTERFACE/operstate"
if [[ ! -f "$OPERSTATE_FILE" ]] || [[ "$(cat "$OPERSTATE_FILE")" != "up" ]]; then
    echo ''
    exit 0
fi

# Function to get byte counts
get_bytes() {
    cat "/sys/class/net/$INTERFACE/statistics/${1}_bytes"
}

# Measure Rx/Tx difference over 1 second
RX1=$(get_bytes rx)
TX1=$(get_bytes tx)
sleep 1
RX2=$(get_bytes rx)
TX2=$(get_bytes tx)

# Calculate speeds in KB/s
RX_RATE=$(( (RX2 - RX1) / 1024 ))
TX_RATE=$(( (TX2 - TX1) / 1024 ))

# Output JSON for Waybar
echo " ${RX_RATE}KB/s  ${TX_RATE}KB/s"
