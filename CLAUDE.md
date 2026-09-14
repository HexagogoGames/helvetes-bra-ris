# dotfiles — instruktioner för Claude Code

Det här är Jakobs rice/dotfiles-repo för en **live** EndeavourOS + Hyprland-dator.
Allt här är symlinkat tillbaka till `~/.config/<namn>` (eller `~/.bashrc`), så det som
ligger i den här mappen är exakt det som faktiskt körs — inte en kopia.

## Viktigt att veta innan du gör något här

- **Detta är en körande session.** Hyprland, waybar, eww, swaync, kitty m.fl. körs live
  medan du jobbar. Redigera filer fritt, men kör **aldrig** `hyprctl reload`, starta om
  waybar/eww/swaync, eller logga ut/starta om utan att uttryckligen fråga användaren
  först — se [[vault/03-felsokning/hyprland-lua-migration]] för varför det just nu är
  extra känsligt.
- Filerna nås via symlinkar (`~/.config/hypr` -> `~/dotfiles/hypr` osv). Det är
  transparent för programmen (XDG Base Directory-spec), men tänk på att en `mv`/`rm`
  av en symlink i `~/.config` inte är samma sak som att ändra filen i `~/dotfiles`.
- `hypr.conf-backup-20260913/` är en **backup** av det gamla `.conf`-baserade systemet,
  kvar tills lua-migreringen är verifierad. Rör den inte utan att fråga.

## Vad som finns här

| Mapp/fil i repot | Symlinkad till | Program |
|---|---|---|
| `hypr/` | `~/.config/hypr` | Hyprland (lua-config, se vault) |
| `hypr.conf-backup-20260913/` | `~/.config/hypr.conf-backup-20260913` | gammal .conf-backup |
| `kitty/` | `~/.config/kitty` | terminal |
| `waybar/` | `~/.config/waybar` | statusbar |
| `eww/` | `~/.config/eww` | widgets |
| `rofi/` | `~/.config/rofi` | app-launcher |
| `swaync/` | `~/.config/swaync` | notiser |
| `wlogout/` | `~/.config/wlogout` | power-meny |
| `wob/` | `~/.config/wob` | volym/ljusstyrka-OSD |
| `cava/` | `~/.config/cava` | ljudvisualisering (i waybar) |
| `btop/` | `~/.config/btop` | systemmonitor |
| `fastfetch/` | `~/.config/fastfetch` | systeminfo-fetch |
| `starship.toml` | `~/.config/starship.toml` | shell-prompt |
| `bashrc` | `~/.bashrc` | shell |

## vault/ — andra hjärnan

`vault/` är en Obsidian-kompatibel anteckningssamling om hela riggen: varför saker är
konfigurerade som de är, beslut som tagits, kända problem, tema/färgval. Den är tänkt
att vara ett levande minne, inte statisk dokumentation.

**Håll den uppdaterad kontinuerligt:**
- Gjorde du en meningsfull ändring i en config? Uppdatera motsvarande fil i
  `vault/01-appar/`.
- Tog ni ett beslut, löste ett problem, eller ändrade riktning? Lägg en rad i
  `vault/02-beslut/changelog.md` (nyast överst) eller en ny fil i `vault/03-felsokning/`
  om det var ett faktiskt fel som löstes.
- Nya idéer/saker att göra senare → `vault/05-todo/wishlist.md`.
- Länka mellan filer med `[[vault/mapp/namn]]`-stil wikilänkar där det är naturligt.

Se `vault/README.md` för full struktur.

## Git

Repot är git-initierat lokalt men **inte** pushat någonstans ännu (användaren gör det
själv). Committa gärna löpande med tydliga meddelanden, men skapa ingen remote och
pusha inget utan att bli ombedd.
