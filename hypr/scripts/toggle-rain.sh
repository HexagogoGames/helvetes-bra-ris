#!/usr/bin/env bash
# Slår på/av regn-shadern (hypr/shaders/rain.glsl) live via hyprctl.
# Rör INGEN configfil - bara en runtime-inställning, försvinner av sig
# själv vid nästa omstart av Hyprland. Se vault/04-tema/regn-shader.md.
STATE="$HOME/.cache/rain-shader-on"
SHADER="$HOME/.config/hypr/shaders/rain.glsl"

if [ -f "$STATE" ]; then
    hyprctl keyword decoration:screen_shader "" >/dev/null
    rm -f "$STATE"
else
    hyprctl keyword decoration:screen_shader "$SHADER" >/dev/null
    touch "$STATE"
fi
