# dotfiles — instruktioner för Claude Code

Det här är Jakobs rice/dotfiles-repo för en **live** EndeavourOS + Hyprland-dator.
Allt här är symlinkat tillbaka till `~/.config/<namn>` (eller `~/.bashrc`), så det som
ligger i den här mappen är exakt det som faktiskt körs — inte en kopia.

## Viktigt att veta innan du gör något här

- **Detta är en körande session.** Hyprland, waybar, eww, swaync, kitty m.fl. körs live
  medan du jobbar. Redigera filer fritt, men kör **aldrig** `hyprctl reload`, starta om
  waybar/eww/swaync, eller logga ut/starta om utan att uttryckligen fråga användaren
  först — oavsett hur trivial ändringen känns.
- Filerna nås via symlinkar (`~/.config/hypr` -> `~/dotfiles/hypr` osv). Det är
  transparent för programmen (XDG Base Directory-spec), men tänk på att en `mv`/`rm`
  av en symlink i `~/.config` inte är samma sak som att ändra filen i `~/dotfiles`.
- Hyprland kör på **lua-config** (`hypr/hyprland.lua` m.fl.) — migreringen från det
  gamla `.conf`-baserade systemet är klar och verifierad med en riktig `hyprctl reload`
  2026-09-14, se [[vault/03-felsokning/hyprland-lua-migration]]. Backupen
  (`hypr.conf-backup-20260913/`) är borttagen.

## Vad som finns här

| Mapp/fil i repot | Symlinkad till | Program |
|---|---|---|
| `hypr/` | `~/.config/hypr` | Hyprland (lua-config, se vault) |
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
| `spicetify/Themes/SvenskSkog/` | `~/.config/spicetify/Themes/SvenskSkog` | Spotify-tema (via spicetify-cli) |

## vault/

`vault/` är en Obsidian-kompatibel anteckningssamling om hela riggen: varför saker är
konfigurerade som de är, beslut som tagits, kända problem, tema/färgval. Den är tänkt
att vara ett levande minne, inte statisk dokumentation.

**Du sköter den här helt automatiskt, löpande, utan att fråga om lov eller vänta på
att bli ombedd:**
- Gjorde du en meningsfull ändring i en config? Uppdatera motsvarande fil i
  `vault/01-appar/` — direkt, som en del av samma svar.
- Togs ett beslut, löstes ett problem, eller ändrades riktning (inklusive sådant som
  kommer fram i en vanlig konversation, inte bara filändringar)? Lägg en rad i
  `vault/02-beslut/changelog.md` (nyast överst) eller en ny fil i `vault/03-felsokning/`
  om det var ett faktiskt fel som löstes.
- Nya idéer/saker att göra senare → `vault/05-todo/wishlist.md`.
- **Allt du väntar på att Jakob ska göra** (en sudo-kommando, ett beslut bara
  han kan ta, en bekräftelse, ett paket han behöver installera) →
  `vault/05-todo/vantar-pa-jakob.md`. Lägg till det direkt när det uppstår,
  ta bort raden (eller flytta till changelogen med datum) så fort det är
  klart — filen ska alltid spegla exakt vad som saknas från hans sida just nu.
- Länka mellan filer med `[[vault/mapp/namn]]`-stil wikilänkar där det är naturligt.
- Trivial finjustering (en pixel hit eller dit) behöver inte loggas — men allt som
  förklarar ett *varför* eller som du själv skulle vilja komma ihåg nästa gång ska in.

Se `vault/README.md` för full struktur.

## Git

Repot har en remote (`github.com/HexagogoGames/helvetes-bra-ris`) och Jakob har gett
löpande klartecken att pusha. Committa löpande med tydliga meddelanden och pusha efter
varje commit utan att fråga om lov varje gång.
