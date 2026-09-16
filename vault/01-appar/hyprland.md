# Hyprland

Version 0.56.2. Config skrivs i **Lua** (nytt system, ersätter det gamla `.conf`/hyprlang-
formatet) — se [[../03-felsokning/hyprland-lua-migration]] för status och kända hål.

## Filer i `hypr/`

- `hyprland.lua` — huvudentry: animationer (`hl.curve`, `hl.animation`), allmänna
  inställningar via `hl.config({...})` (gaps_in 4 / gaps_out 6, border_size 1,
  rounding 18, dwindle-layout, blur, vrr på, xwayland force_zero_scaling),
  och `require()` av modulerna nedan — inklusive `colors` (se nedan).
- `colors.lua` — **ny 2026-09-15**, kantfärger (`active_border`/`inactive_border`)
  i en egen fil, `require("colors")`:ad från `hyprland.lua`. Skrivs om av
  `wallust` vid varje bakgrundsbyte eller kopieras från `wallust/anchor/` för
  ankarbilden — inte gitspårad längre, se [[../04-tema/dynamiskt-tema]].
- `monitors.lua` — monitor-setup. **Tom just nu**, se felsökningsnoten.
- `input.lua` — tangentbord/mus-inställningar.
- `keybinds.lua` — alla keybindings, inkl. `XF86PowerOff` → wlogout-menyn
  (2026-09-15, se [[../02-beslut/changelog]]).
- `rules.lua` — fönsterregler.
- `autostart.lua` — vad som startar vid `hyprland.start`: `hyprpaper`
  (wallpaper, ersatte `swaybg` 2026-09-14), `hyprctl setcursor Adwaita 24`,
  `hypridle`, `ac-sound-watch.sh`, `wob-init.sh`, `eww daemon`, `waybar`,
  `swaync`, polkit-agent, samt `ssh-add` av `id_ed25519` mot
  `$XDG_RUNTIME_DIR/ssh-agent.socket`.
- `hyprlock.conf` / `hypridle.conf` — skärmlås/idle (fortfarande i klassiskt
  hyprlang-format, inte lua — separata program, inte del av migreringen).
  `hypridle.conf`-tider (uppdaterade 2026-09-16): dimma 5 min, lås 10 min,
  skärm av 15 min, `systemctl suspend` 20 min.
- `hyprpaper.conf` — bakgrundsbild, pekar på en stabil symlink
  (`images/backgrounds/.current.jpg`) som `wallpaper-cycle.sh` uppdaterar,
  se [[../04-tema/dynamiskt-tema]].
- `scripts/` — `ac-sound-watch.sh`, `osd-brightness.sh`, `osd-volume.sh`,
  `wob-init.sh`, `wallpaper-cycle.sh` (ny 2026-09-15, orkestrerar dynamiskt
  tema + bakgrundsbyte, körs av `systemd/user/wallpaper-cycle.timer` — inte
  av Hyprland/`autostart.lua`).
- `sounds/` — ljudfiler för notiser/events.

## Relaterat

- [[../04-tema/design|Tema/färger]] — samma palett som kitty/starship (för
  ankarbilden; övriga bakgrunder får ett eget dynamiskt tema, se
  [[../04-tema/dynamiskt-tema]]).
- Gamla `hypr.conf-backup-20260913/` är borttagen (städat 2026-09-14),
  finns bara kvar i git-historiken.
