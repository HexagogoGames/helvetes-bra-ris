# Dotfiles-struktur

`~/dotfiles/` är källan till sanning. Varje mapp/fil där är flyttad från sin
ursprungliga plats i `~/.config` (eller `~` för `.bashrc`) och ersatt med en symlink
på originalplatsen, så program hittar sin config precis som förut — se
[[../../CLAUDE.md]] för hela mappningstabellen.

## Varför symlinkar och inte t.ex. GNU Stow?

Enkelt, explicit, och lätt att förstå/felsöka för en person — varje symlink skapades
manuellt och kan verifieras med `readlink -f`. Stow hade gett samma resultat men med
ett extra abstraktionslager.

## `rice.code-workspace`

En VS Code multi-root-workspace i repo-roten som öppnar alla rice-mappar (inkl.
`vault/`) i ett fönster. Nås via ⚙-knappen längst till vänster i waybar
(`custom/hyprland-config`-modulen i `waybar/config.jsonc`).

## Vad som *inte* flyttades in

- `~/.gitconfig` — ligger kvar i hemroten, inte del av rice-configen (kan läggas till
  senare om det blir aktuellt).
- Wallpapers (`~/Bilder/Wallpapers/`) — bilder, inte config; versioneras inte här.
- Fonts — inga custom fonts hittade lokalt (`~/.local/share/fonts` finns inte); systemet
  använder troligen paketerade Nerd Fonts.
