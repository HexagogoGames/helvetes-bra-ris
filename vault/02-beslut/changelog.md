# Changelog

Nyast överst.

## 2026-09-14 — Hyprland lua-migrering klar, backup borttagen

Jakob startade om datorn. `hyprctl systeminfo` bekräftar `configProvider: lua`,
`hyprctl configerrors` tomt, och autostart (waybar/swaync/eww/swaybg/cava) kom upp
korrekt. Lua-configen är alltså verifierad i praktiken, inte bara syntaktiskt. Tog
bort `hypr.conf-backup-20260913/` (repo + symlink i `~/.config/`) — behövs inte
längre. Se [[../03-felsokning/hyprland-lua-migration]].

Samtidigt: gjorde vault-hanteringen i `CLAUDE.md` till en tydlig, obligatorisk rutin
(sköts automatiskt, utan att fråga om lov) istället för en rekommendation, och döpte
om vault-rubrikerna till bara "Vault"/`vault/` (utan undertitel).

## 2026-09-14 — Hyprland lua-config verifierad giltig

Körde `Hyprland --verify-config` mot `hypr/hyprland.lua` (riskfritt, startar ingen
compositor). Resultat: `config ok`, exit 0. Alla `.lua`-filer passerade även
`luac5.4 -p`. Se [[../03-felsokning/hyprland-lua-migration]] för detaljer — kvarstår
fortfarande att verifiera beteende i praktiken med en riktig reload.

## 2026-09-14 — Dotfiles-migrering till `~/dotfiles/`

- Flyttade all rice-config (`hypr`, `hypr.conf-backup-20260913`, `kitty`, `waybar`,
  `eww`, `rofi`, `swaync`, `wlogout`, `wob`, `cava`, `btop`, `fastfetch`,
  `starship.toml`, `~/.bashrc`, `rice.code-workspace`) från `~/.config`/`~` till
  `~/dotfiles/`, med symlinkar tillbaka på originalplatserna.
- **Varför:** köra Claude Code i hela `~/.config` exponerade orelaterade saker (gh-token,
  Firefox-profil, m.m.) — se resonemanget i chatthistoriken. Ett dedikerat
  git-versionerat dotfiles-repo med bara rice-relaterat innehåll är säkrare och ger
  historik/ångra.
- Verifierat: allt innehåll byte-identiskt efter flytt (md5sum, följt symlinkar med
  `-L`), inga trasiga symlinkar, alla körande processer (Hyprland, waybar, kitty, eww,
  swaync, cava) fortsatte köra opåverkade, `hyprctl configerrors` oförändrat tomt.
- Uppdaterade `rice.code-workspace` (flyttad in i repot) med alla mappar, inte bara de
  6 ursprungliga — samt waybar-knappen (`custom/hyprland-config`) som öppnar den.
- Upptäckte under tiden en pågående, ännu overifierad Hyprland lua-migrering — se
  [[../03-felsokning/hyprland-lua-migration]]. Rörde inget på WM-nivå.
- Skapade `CLAUDE.md` och den här `vault/`-strukturen.
- Git-repo initierat lokalt. **Ingen remote/push gjord** — Jakob gör det själv.
