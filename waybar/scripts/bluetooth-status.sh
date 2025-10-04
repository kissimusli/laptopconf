#!/bin/sh

if ! bluetoothctl show | grep -q "Powered: yes"; then
    echo "Off"
    exit
fi

CONNECTED=$(bluetoothctl info | grep "Connected: yes")
if [ -n "$CONNECTED" ]; then
    echo "On"
else
    echo "No device"
fi
