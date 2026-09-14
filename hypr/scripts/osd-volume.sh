#!/bin/bash
# Ändrar volym och skickar nya värdet till wobs overlay-bar.
WOB_SOCK="$XDG_RUNTIME_DIR/wob.sock"

case "$1" in
    up)   wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+ ;;
    down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
    mute) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
esac

muted=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | awk '{print $2}')
vol_frac=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | grep -oP '(?<=Volume: )[0-9.]+')
vol=$(python3 -c "print(min(100, round(${vol_frac:-0} * 100)))" 2>/dev/null || echo 0)

if [ "$muted" = "yes" ]; then
    echo 0 > "$WOB_SOCK"
else
    echo "${vol:-0}" > "$WOB_SOCK"
fi
