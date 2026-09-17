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
- `keybinds.lua` — alla keybindings, inkl. `XF86PowerOff` → `power-button.sh`
  (2026-09-15/18, se [[../02-beslut/changelog]]) och skärmdump →
  `screenshot.sh` (2026-09-18).
- `rules.lua` — fönsterregler.
- `autostart.lua` — vad som startar vid `hyprland.start`: `hyprpaper`
  (wallpaper, ersatte `swaybg` 2026-09-14), `hyprctl setcursor Adwaita 24`,
  `hypridle`, `hyprsunset` (blåljusfilter, ny 2026-09-18),
  `ac-sound-watch.sh`, `wob-init.sh`, `eww daemon`, `waybar`, `swaync`,
  polkit-agent, samt `ssh-add` av `id_ed25519` mot
  `$XDG_RUNTIME_DIR/ssh-agent.socket`.
- `hyprlock.conf` / `hypridle.conf` — skärmlås/idle (fortfarande i klassiskt
  hyprlang-format, inte lua — separata program, inte del av migreringen).
  `hypridle.conf`-tider (uppdaterade 2026-09-16): dimma 5 min, lås 10 min,
  skärm av 15 min, `systemctl suspend` 20 min. `hyprlock.conf`s bakgrund
  pekar på samma `.current.jpg`-symlink som hyprpaper (fixat 2026-09-18, se
  [[../03-felsokning/hyprlock-svart-bakgrund]]).
- `hyprpaper.conf` — bakgrundsbild, pekar på en stabil symlink
  (`images/backgrounds/.current.jpg`) som `wallpaper-cycle.sh` uppdaterar,
  se [[../04-tema/dynamiskt-tema]].
- `hyprsunset.conf` — **ny 2026-09-18**, blåljusfilter. Två profiler: normal
  från 07:30, varmare (4500K) från 20:00. Se
  https://wiki.hypr.land/Hypr-Ecosystem/hyprsunset/ för formatet (`profile
  { time = HH:MM; temperature = N; identity = bool }`) — går även att styra
  live via `hyprctl hyprsunset temperature/gamma/identity/reset/profile`.
- `scripts/` — `ac-sound-watch.sh`, `osd-brightness.sh`, `osd-volume.sh`,
  `wob-init.sh`, `wallpaper-cycle.sh` (orkestrerar dynamiskt tema +
  bakgrundsbyte, körs av `systemd/user/wallpaper-cycle.timer` — inte av
  Hyprland/`autostart.lua`), `power-button.sh` (2026-09-18, filtrerar bort
  strömknappens "eko" efter vila, se
  [[../03-felsokning/strömknapp-ekar-efter-vila]]), `screenshot.sh`
  (2026-09-18, skärmdump + urklipp + notis med "Redigera"-knapp som öppnar
  `satty`).
- `sounds/` — ljudfiler för notiser/events.

## Relaterat

- [[../04-tema/design|Tema/färger]] — samma palett som kitty/starship (för
  ankarbilden; övriga bakgrunder får ett eget dynamiskt tema, se
  [[../04-tema/dynamiskt-tema]]).
- Gamla `hypr.conf-backup-20260913/` är borttagen (städat 2026-09-14),
  finns bara kvar i git-historiken.
