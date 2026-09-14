#!/bin/bash
# Skapar wobs pipe och startar wob som läser ifrån den.
WOB_SOCK="$XDG_RUNTIME_DIR/wob.sock"
[ -p "$WOB_SOCK" ] || mkfifo -m600 "$WOB_SOCK"
tail -f "$WOB_SOCK" | wob -c ~/.config/wob/wob.ini
