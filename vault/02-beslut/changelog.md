# Changelog

Nyast överst.

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
