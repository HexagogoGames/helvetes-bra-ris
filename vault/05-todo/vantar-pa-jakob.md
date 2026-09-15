# Väntar på Jakob

Saker jag inte kan eller inte ska göra själv — kräver sudo, ett beslut bara
Jakob kan ta, eller en handling utanför den här maskinens config (t.ex. testa
något live och bekräfta). Håll den här listan aktuell: ta bort raden när
punkten är klar, eller flytta den till [[../02-beslut/changelog]] med datum.

## Aktivt öppna

- **`linux-surface`-kärnan — nu roten till TVÅ separata problem, inte bara
  ett.** Kör vanlig `linux`-kärna utan Surface-specifika drivrutiner
  (`surface_aggregator` m.fl.). Färdig installationsplan (research klar
  2026-09-15, verifierad mot den här maskinen — Secure Boot avstängt,
  dracut redan initramfs-verktyg, en känd Surface Laptop 6-specifik
  kärnparameter som kan vara direkt relevant för strömknappsproblemet):
  se [[linux-surface-installation]]. **Inte påbörjat** — stort
  systembeslut, Jakob sa "senare".
  1. *Uppstarts-/suspendproblem (`s2idle`)*: 2026-09-15, locket stängdes,
     datorn gick i viloläge och vaknade aldrig — total låsning, krävde
     20-30 sek intryckt strömknapp för hård-reset.
  2. *Strömknappen syns inte alls för mjukvaran*: bekräftat 2026-09-15 —
     `PNP0C0C` (ACPI:s standard-ID för en strömknapp) finns inte i
     `/sys/bus/acpi/devices/` överhuvudtaget, bara locket (`PNP0C0D`). Varken
     `systemd-logind` eller Hyprland kan alltså någonsin se ett kort
     knapptryck — min `XF86PowerOff`-keybind och `HandlePowerKey=ignore`-
     configen (se nedan) är korrekt gjorda men **kan inte ha någon effekt**
     förrän kärnan faktiskt exponerar knappen som en input-enhet. Det
     betyder också att min ursprungliga diagnos av "stänger av direkt"-
     buggen (logind vinner racet mot Hyprland) troligen var ofullständig —
     det som stängde av datorn måste ha skett i firmware/EC, under OS-nivå,
     samma lager som orsakar `s2idle`-låsningen. Se
     [[../03-felsokning/strömknapp-syns-inte]].

## Klart, men verkan okänd tills linux-surface är på plats

- `hypr/keybinds.lua` (`XF86PowerOff` → wlogout) och
  `/etc/systemd/logind.conf.d/power-button.conf`
  (`HandlePowerKey=ignore`/`HandlePowerKeyLongPress=poweroff`) sitter båda
  rätt och är tekniskt korrekta — men **overifierbara** tills strömknappen
  syns för OS:et alls. Inget mer att göra här förrän `linux-surface` är
  installerad.

## Löst (kvar som referens en kort tid)

- ~~wallust AUR-bygge (checksummefel)~~ — löst 2026-09-15,
  `updpkgsums && makepkg -si` i `~/.cache/yay/wallust`.
- ~~Dynamiskt wallust-tema inte aktiverat~~ — löst 2026-09-15, aktiverat live
  (`wallpaper-cycle.timer` kör nu, klockstyrt varje heltimme).
