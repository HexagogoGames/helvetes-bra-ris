# kitty

Terminalemulator. Config: `kitty/kitty.conf`.

- **Font:** IBM Plex Mono, storlek 12 — [[../04-tema/design|samma font som resten av riggen]].
  Saknar Nerd Font-ikonglyfer, så `symbol_map` renderar bara de intervallen
  från JetBrainsMono Nerd Font Mono istället för att byta hela typsnittet.
- **Färger:** dynamiska sedan 2026-09-15, se [[../04-tema/dynamiskt-tema]] —
  ligger i `kitty/colors.conf` (egen fil, `include`:ad från `kitty.conf`),
  skrivs om av `wallust` vid varje bakgrundsbyte eller kopieras från
  `wallust/anchor/kitty-colors.conf` för ankarbilden (Svensk skog-paletten).
  **Inte** en gitspårad fil längre, se `.gitignore`.
- **`background_opacity`:** 0.75 (sänkt från 0.85 2026-09-16 på Jakobs
  begäran, mer genomskinlig). Kombineras med Hyprlands blur
  (Glassy-estetiken, `decoration.blur` i `hyprland.lua`).
- `sounds/` — ljudfiler för terminalen (felljud, `bell.wav`).
- **Reload:** `ctrl+shift+f5` (`load_config_file`) laddar om configen i
  redan öppna fönster utan att starta om kitty — manuellt, ingen automatisk
  filbevakning. Behövs efter varje bakgrundsbyte om man vill se den nya
  färgpaletten i ett redan öppet fönster; nya fönster som öppnas efter ett
  bakgrundsbyte får de uppdaterade färgerna automatiskt.
