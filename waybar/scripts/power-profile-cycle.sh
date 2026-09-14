#!/usr/bin/env bash
# Växlar power-profiles-daemon till nästa läge och knuffar waybar att
# uppdatera custom/power-profile direkt istället för att vänta på intervallet.

current=$(powerprofilesctl get 2>/dev/null)

case "$current" in
    performance)
        next="balanced"
        ;;
    balanced)
        next="power-saver"
        ;;
    power-saver)
        next="performance"
        ;;
    *)
        next="balanced"
        ;;
esac

powerprofilesctl set "$next"
pkill -RTMIN+20 waybar 2>/dev/null
