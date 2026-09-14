# waybar

Statusbar. Config: `waybar/config.jsonc` + `waybar/style.css`.

## Moduler (custom, vänster→höger ordning i bar)

- **`custom/hyprland-config`** (⚙) — öppnar `~/dotfiles/rice.code-workspace` i VS Code.
  Uppdaterad 2026-09-14 när workspace-filen flyttades in i dotfiles.
- **`custom/gpu`** — kör `scripts/gpu.sh`, klick öppnar `intel_gpu_top` i ett flytande
  kitty-fönster (`--class btop-float`).
- **`custom/cava`** — ljudvisualisering, kör `scripts/cava-waybar.sh` som i sin tur
  startar `cava -p ~/.config/cava/waybar.conf` (se [[cava]]).
- **`custom/power-profile`** — klick kör `scripts/power-profile-cycle.sh`.
- Batteri/wifi/volym-moduler öppnar eww-widgets (`eww open wifi-menu/volume-menu/battery-menu --toggle`).
- Flera moduler öppnar `btop` i ett flytande kitty-fönster (`--class btop-float`) för
  snabb systemvy.

## scripts/

`cava-waybar.sh`, `gpu.sh`, `power-profile.sh`, `power-profile-cycle.sh`.

## Relaterat

[[cava]], [[btop]], [[eww]]
