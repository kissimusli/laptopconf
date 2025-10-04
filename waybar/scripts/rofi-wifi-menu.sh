#!/usr/bin/env bash

# List Wi-Fi networks using nmcli
wifi_list=$(nmcli -t -f SSID,SECURITY dev wifi | grep -v "^--" | uniq | awk -F: '{print $1}' | sort | uniq)

# Show the list in rofi
chosen_network=$(echo "$wifi_list" | rofi -dmenu -p "Wi-Fi SSID")

# Exit if nothing selected
[ -z "$chosen_network" ] && exit

# Check if the network is already known
known=$(nmcli connection show | grep -F "$chosen_network")

#if [ -n "$known" ]; then
    # Already known network, just connect
#    nmcli connection up "$chosen_network"
#else
    # Prompt for password
    wifi_password=$(rofi -dmenu -p "Enter password for $chosen_network")
    nmcli device wifi connect "$chosen_network" password "$wifi_password"
#fi
