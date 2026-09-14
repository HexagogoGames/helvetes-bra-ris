#!/usr/bin/env bash
# Visar aktivt power-profiles-daemon-läge i waybar (custom/power-profile).
# "power-saver" visas som "Quiet Mode" - bara ett visningsnamn, det
# tekniska läget i power-profiles-daemon heter fortfarande power-saver.

profile=$(powerprofilesctl get 2>/dev/null)

case "$profile" in
    performance)
        icon="󰓅"
        label="Performance"
        class="performance"
        ;;
    balanced)
        icon="󰗑"
        label="Balanced"
        class="balanced"
        ;;
    power-saver)
        icon="󰒲"
        label="Quiet Mode"
        class="power-saver"
        ;;
    *)
        icon="?"
        label="Okänt (${profile:-inget svar})"
        class="unknown"
        ;;
esac

printf '{"text":"%s","tooltip":"Power-läge: %s\\n\\nVänsterklicka för att byta läge","class":"%s","alt":"%s"}\n' \
    "$icon" "$label" "$class" "$profile"
