#!/bin/bash
# Spelar ett ljud när strömkabeln kopplas in/ur. Ingen root behövs -
# /sys/class/power_supply/*/online är läsbar för alla.
#
# Döda ev. gamla instanser av sig själv först - samma mönster/sårbarhet som
# cava-waybar.sh hade (se vault/03-felsokning/cava-process-lacka.md): en
# oändlig bakgrundsloop dör inte automatiskt vid omstart utan att dödas
# explicit, och två samtidiga instanser skulle spela varje ljud dubbelt.
self="$(readlink -f "$0")"
for pid in $(pgrep -f "$self"); do
    [ "$pid" != "$$" ] && kill -9 "$pid" 2>/dev/null
done

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
