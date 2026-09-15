#!/bin/bash
# Skapar wobs pipe och startar wob som läser ifrån den.
#
# Döda ev. gamla instanser av sig själv/wob först - samma mönster/sårbarhet
# som cava-waybar.sh hade (se vault/03-felsokning/cava-process-lacka.md):
# en strömmande tail-f|wob-pipeline dör inte automatiskt om något startar
# om den utan att döda den gamla först.
self="$(readlink -f "$0")"
for pid in $(pgrep -f "$self"); do
    [ "$pid" != "$$" ] && kill -9 "$pid" 2>/dev/null
done
pkill -9 -f "tail -f .*wob.sock" 2>/dev/null
pkill -9 -x wob 2>/dev/null

WOB_SOCK="$XDG_RUNTIME_DIR/wob.sock"
[ -p "$WOB_SOCK" ] || mkfifo -m600 "$WOB_SOCK"
tail -f "$WOB_SOCK" | wob -c ~/.config/wob/wob.ini
