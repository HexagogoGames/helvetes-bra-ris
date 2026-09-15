#!/bin/bash
# Strömmande cava-visualiserare för waybar, byggd av block-tecken.
#
# Döda ev. gamla instanser av sig själv/cava först. Utan detta läcker en ny
# cava-process varje gång waybar startas om (t.ex. Super+Shift+R) - den gamla
# cava-waybar.sh dör inte med waybar (blir barn till init istället) och
# fortsätter köra i bakgrunden för evigt. Hittat 2026-09-15: 22 övergivna
# cava-processer efter en session med många waybar-omstarter, se
# vault/03-felsokning/cava-process-lacka.md.
self="$(readlink -f "$0")"
for pid in $(pgrep -f "$self"); do
    [ "$pid" != "$$" ] && kill -9 "$pid" 2>/dev/null
done
pkill -9 -f "cava -p .*cava/waybar.conf" 2>/dev/null

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
