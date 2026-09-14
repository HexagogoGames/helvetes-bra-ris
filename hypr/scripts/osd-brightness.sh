#!/bin/bash
# Ändrar ljusstyrka och skickar nya värdet till wobs overlay-bar.
WOB_SOCK="$XDG_RUNTIME_DIR/wob.sock"

case "$1" in
    up)   brightnessctl set +5% ;;
    down) brightnessctl set 5%- ;;
esac

cur=$(brightnessctl get)
max=$(brightnessctl max)
pct=$(( cur * 100 / max ))
echo "$pct" > "$WOB_SOCK"
