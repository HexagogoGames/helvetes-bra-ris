#!/bin/bash
# Strömmande cava-visualiserare för waybar, byggd av block-tecken.
BARS="▁▂▃▄▅▆▇█"

cava -p ~/.config/cava/waybar.conf 2>/dev/null | while IFS=';' read -ra vals; do
    out=""
    for v in "${vals[@]}"; do
        [ -z "$v" ] && continue
        idx=$v
        [ "$idx" -gt 7 ] 2>/dev/null && idx=7
        [ "$idx" -lt 0 ] 2>/dev/null && idx=0
        out+="${BARS:$idx:1}"
    done
    printf '{"text": "%s"}\n' "$out"
done
