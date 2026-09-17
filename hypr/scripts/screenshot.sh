#!/usr/bin/env bash
# Skärmdump (valt område eller helskärm) - sparas + kopieras till urklipp,
# och en notis dyker upp med en "Redigera"-knapp som öppnar skärmdumpen i
# satty (annotering: pilar, text, suddning osv). Klickar man inte på
# knappen händer inget mer. Se vault/01-appar/hyprland.md.
set -euo pipefail

mode="${1:-region}"

mkdir -p "$HOME/Bilder"
file="$HOME/Bilder/Screenshot-$(date +%Y-%m-%d_%H-%M-%S).png"

case "$mode" in
    region)
        # slurp avbryts (Esc/högerklick) med felkod - gör då ingenting alls,
        # ingen tom skärmdump eller notis.
        area="$(slurp)" || exit 0
        grim -g "$area" "$file"
        ;;
    full)
        grim "$file"
        ;;
    *)
        echo "screenshot.sh: okänt läge '$mode' (vänta 'region' eller 'full')" >&2
        exit 1
        ;;
esac

wl-copy < "$file"

# -A implicerar --wait: väntar tills notisen klickas/avfärdas/går ut, och
# skriver ut vilken knapp (om någon) som klickades.
action=$(notify-send -A "edit=Redigera" -i "$file" "Skärmdump sparad" "Kopierad till urklipp" 2>/dev/null || true)

if [ "$action" = "edit" ]; then
    satty --filename "$file"
fi
