# kitty

Terminalemulator. Config: `kitty/kitty.conf`.

- **Font:** JetBrainsMono Nerd Font, storlek 12 — [[../04-tema/design|samma font som resten av riggen]].
- **Färger:** bakgrund `#070910`, text `#e8f1ff` (mörkt tema, matchar starship/hyprlock).
- **`background_opacity`:** 0.88 (genomskinlig, kräver compositor-blur från Hyprland).
- `sounds/` — ljudfiler för terminalen.
- Live-reload: kitty kör en `kitten __watch_conf__`-process per fönster som bevakar
  `kitty.conf` och laddar om automatiskt vid ändring — inget behöver startas om manuellt
  efter en configändring.
