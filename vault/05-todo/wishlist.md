# Todo / wishlist

- [x] ~~eww "systemmeny"~~ — **byggd och live 2026-09-15.** Fristående 4:e meny
      (`system-menu` i `eww.yuck`), öppnas via en ny 📊-modul i waybar
      (`custom/systemstats`). Visar Minne/Temperatur/Nätverk + snabbåtgärder
      (Wifi på/av, Stör ej, Ljudinställningar → pavucontrol, Lås skärm).
      **CPU och GPU flyttades INTE in** — Jakob ville ha dem kvar synliga direkt
      i waybar (egna moduler, klick öppnar btop/intel_gpu_top som förut). Ingen
      utökad vy/grafer byggd (bedömdes som "hålla det enkelt", jfr swaync-
      beslutet). Datakälla: `eww/scripts/system-stats.sh` (delad med waybars
      tooltip via `waybar/scripts/systemstats-tooltip.sh`). De befintliga
      `wifi-menu`/`volume-menu`/`battery-menu` rördes inte, finns kvar separat.
- [x] ~~Testa en *riktig* `hyprctl reload`~~ — gjort via full omstart 2026-09-14,
      lua-configen verifierad fungerande i praktiken. Se
      [[../03-felsokning/hyprland-lua-migration]].
- [ ] ~~Extrahera och dokumentera `rofi/colors.rasi`-paletten~~ — **överspelad**:
      hela paletten görs om till Gruvbox Dark i den pågående temaomdesignen
      ([[../04-tema/design]]), den gamla `rofi/colors.rasi` ersätts ändå.
- [x] ~~Bestäm när `hypr.conf-backup-20260913/` kan arkiveras/tas bort~~ — borttagen
      2026-09-14, se changelog.
- [ ] Ta ställning till om `~/.gitconfig` ska in i dotfiles-repot.
- [x] ~~Skapa GitHub-repo och pusha~~ — `HexagogoGames/helvetes-bra-ris`, klart
      2026-09-14.
