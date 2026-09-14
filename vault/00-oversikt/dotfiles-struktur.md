# Dotfiles-struktur

`~/dotfiles/` är källan till sanning. Varje mapp/fil där är flyttad från sin
ursprungliga plats i `~/.config` (eller `~` för `.bashrc`) och ersatt med en symlink
på originalplatsen, så program hittar sin config precis som förut — se
[[../../CLAUDE.md]] för hela mappningstabellen.

## Varför symlinkar och inte t.ex. GNU Stow?

Enkelt, explicit, och lätt att förstå/felsöka för en person — varje symlink skapades
manuellt och kan verifieras med `readlink -f`. Stow hade gett samma resultat men med
ett extra abstraktionslager.

## Öppna dotfiles snabbt

⚙-knappen längst till vänster i waybar (`custom/dotfiles` i `waybar/config.jsonc`)
kör `code --new-window ~/dotfiles` — öppnar hela repot i VS Code. Fanns tidigare som
en separat `rice.code-workspace`-multi-root-fil, men den togs bort 2026-09-14 som
onödigt lager (mappen visar samma innehåll direkt).

## Vad som *inte* flyttades in

- `~/.gitconfig` — ligger kvar i hemroten, inte del av rice-configen (kan läggas till
  senare om det blir aktuellt).
- Wallpapers (`~/Bilder/Wallpapers/`) — bilder, inte config; versioneras inte här.
- Fonts — inga custom fonts hittade lokalt (`~/.local/share/fonts` finns inte); systemet
  använder troligen paketerade Nerd Fonts.
