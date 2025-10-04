#!/bin/bash

choice=$(printf "Enable Lockdown Mode\nDisable Lockdown Mode\nCheck Lockdown Status\nConnect\nDisconnect\nCheck Status" | wofi --dmenu --prompt "Mullvad Configuration")

case "$choice" in
    "Check Lockdown Status")
        status=$(mullvad lockdown-mode get)
        notify-send "Mullvad Lockdown Status" "$status"
        ;;
    "Enable Lockdown Mode")
        mullvad lockdown-mode set on
        notify-send "Mullvad" "Lockdown mode enabled"
        ;;
    "Disable Lockdown Mode")
        mullvad lockdown-mode set off
        notify-send "Mullvad" "Lockdown mode disabled"
        ;;
    "Connect")
        mullvad connect
        notify-send "Mullvad" "Connected"
        ;;
    "Disconnect")
        mullvad disconnect
        notify-send "Mullvad" "Disconnected"
        ;;
    "Check Status")
        status=$(mullvad status)
        notify-send "Mullvad Connection Status" "$status"
        ;;

    *)
        exit 0
        ;;
esac
