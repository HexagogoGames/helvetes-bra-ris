# Todo / wishlist

- [ ] **Nytt: eww "systemmeny" (GNOME quick-settings-stil)** — separat projekt, egen
      designrunda när temat är klart. Bestämt hittills (2026-09-14, under
      tema-genomgången i [[../04-tema/design]]):
  - Två egenbyggda eww-vyer (ingen btop i flödet): en **kompakt popup** (öppnas
    t.ex. via klick i waybar) och en **utökad vy** för mer detalj — båda helt
    eww, inte terminal-TUI.
  - Innehåll: CPU/minne/nätverk-info + **några snabb-åtgärder** (t.ex. wifi-toggle,
    ljudenhet-byte) i samma meny.
  - Öppen fråga att ta med till den egna designrundan: ska den här nya menyn
    **ersätta/slå ihop med** de befintliga separata `wifi-menu`/`volume-menu`/
    `battery-menu`-eww-widgetsen (se [[../01-appar/eww]]), eller finnas vid sidan
    av dem som en fjärde, ren systemstatus-meny? Exakt vilka snabb-åtgärder,
    exakt layout/grafer i utökad vy — inget av det är bestämt än.
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
