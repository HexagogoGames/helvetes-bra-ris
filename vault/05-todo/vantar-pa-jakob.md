# Väntar på Jakob

Saker jag inte kan eller inte ska göra själv — kräver sudo, ett beslut bara
Jakob kan ta, eller en handling utanför den här maskinens config (t.ex. testa
något live och bekräfta). Håll den här listan aktuell: ta bort raden när
punkten är klar, eller flytta den till [[../02-beslut/changelog]] med datum.

## Aktivt öppna

- **Uppstarts-/suspendproblem (Surface Laptop 6, s2idle).** 2026-09-15: locket
  stängdes, datorn gick i `s2idle`-viloläge och vaknade aldrig — total låsning
  (inga lampor/fläktar), krävde 20-30 sek intryckt power-knapp för att
  hård-resetta. Kör vanlig `linux`-kärna utan Surface-specifika EC-patchar.
  Rekommenderad fix: installera `linux-surface`-kärnan
  (https://github.com/linux-surface/linux-surface, kräver eget repo/nyckel,
  sudo, och ett omstart-val av kärna). **Inte påbörjat** — stort systembeslut,
  Jakob avgör om/när. Se [[../03-felsokning/hyprpaper-current-symlink-saknades]]
  för en bieffekt av samma omstart (inte relaterad orsak, bara samtidig).

## Löst (kvar som referens en kort tid)

- ~~wallust AUR-bygge (checksummefel)~~ — löst 2026-09-15,
  `updpkgsums && makepkg -si` i `~/.cache/yay/wallust`.
- ~~Dynamiskt wallust-tema inte aktiverat~~ — löst 2026-09-15, aktiverat live
  (`wallpaper-cycle.timer` kör nu, klockstyrt varje heltimme).
- ~~Strömknappen stänger av direkt vid kort tryck~~ — löst 2026-09-15,
  `logind.conf.d/power-button.conf` på plats och bekräftat aktivt. Se
  [[../03-felsokning/logind-omstart-svart-skarm]] för en läskig bieffekt
  under själva installationen (löste sig med en ren omstart, ingen
  dataförlust).
