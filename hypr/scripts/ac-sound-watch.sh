#!/bin/bash
# Spelar ett ljud när strömkabeln kopplas in/ur. Ingen root behövs -
# /sys/class/power_supply/*/online är läsbar för alla.

AC="/sys/class/power_supply/ADP1/online"
PLUG_SOUND="$HOME/.config/hypr/sounds/power-plug.wav"
UNPLUG_SOUND="$HOME/.config/hypr/sounds/power-unplug.wav"

prev=$(cat "$AC" 2>/dev/null || echo 1)

while true; do
    sleep 1
    cur=$(cat "$AC" 2>/dev/null || echo "$prev")
    if [ "$cur" != "$prev" ]; then
        if [ "$cur" = "1" ]; then
            paplay "$PLUG_SOUND" 2>/dev/null
        else
            paplay "$UNPLUG_SOUND" 2>/dev/null
        fi
    fi
    prev="$cur"
done
