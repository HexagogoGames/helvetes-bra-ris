# Hyprland

Version 0.56.2. Config skrivs i **Lua** (nytt system, ersätter det gamla `.conf`/hyprlang-
formatet) — se [[../03-felsokning/hyprland-lua-migration]] för status och kända hål.

## Filer i `hypr/`

- `hyprland.lua` — huvudentry: animationer (`hl.curve`, `hl.animation`), allmänna
  inställningar via `hl.config({...})` (gaps 5/10, border 2, rounding 8, dwindle-layout,
  blur, vrr på, xwayland force_zero_scaling), och `require()` av modulerna nedan.
- `monitors.lua` — monitor-setup. **Tom just nu**, se felsökningsnoten.
- `input.lua` — tangentbord/mus-inställningar.
- `keybinds.lua` — alla keybindings.
- `rules.lua` — fönsterregler.
- `autostart.lua` — vad som startar vid `hyprland.start`: `swaybg` (wallpaper),
  `hypridle`, `ac-sound-watch.sh`, `wob-init.sh`, `eww daemon`, `waybar`, `swaync`,
  polkit-agent, samt `ssh-add` av `id_ed25519` mot `$XDG_RUNTIME_DIR/ssh-agent.socket`.
- `hyprlock.conf` / `hypridle.conf` — skärmlås (fortfarande i klassiskt hyprlang-format,
  inte lua — separata program, inte del av migreringen).
- `scripts/` — `ac-sound-watch.sh`, `osd-brightness.sh`, `osd-volume.sh`, `wob-init.sh`.
- `sounds/` — ljudfiler för notiser/events.

## Relaterat

- [[../04-tema/design|Tema/färger]] — samma palett som kitty/starship.
- `hypr.conf-backup-20260913/` — gamla `.conf`-filerna, se felsökningsnoten.
