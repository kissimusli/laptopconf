#!/bin/bash

# Get Mullvad connection status
status=$(mullvad status | grep -o "Connected")

if [ "$status" == "Connected" ]; then
    echo "{\"text\": \" \", \"class\": \"connected\"}"
else
    echo "{\"text\": \" \", \"class\": \"disconnected\"}"
fi
