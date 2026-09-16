# Väntar på Jakob

Saker jag inte kan eller inte ska göra själv — kräver sudo, ett beslut bara
Jakob kan ta, eller en handling utanför den här maskinens config (t.ex. testa
något live och bekräfta). Håll den här listan aktuell: ta bort raden när
punkten är klar, eller flytta den till [[../02-beslut/changelog]] med datum.

## Aktivt öppna

- **`s2idle`-viloläget är INTE verifierat säkert än — rör det inte
  oövervakat.** Jakob installerade `linux-surface` 2026-09-16 (se
  [[../02-beslut/changelog]]), men har **inte rört
  suspend/vila-problemet specifikt** ("jag har inte rört suspend/vila
  problemet"). `hypridle.conf` har fortfarande kvar sin regel
  `timeout = 900 → systemctl suspend` (somnar automatiskt efter 15 min
  inaktivitet, oavsett lock). `/proc/acpi/wakeup` visar fortfarande inga
  registrerade väck-källor för lock/knapp ens med surface-kärnan (kan bero
  på att `surface_aggregator` hanterar det på ett annat sätt jag inte kan
  se härifrån — eller inte). **Okänt om resume faktiskt fungerar nu.**
  Rekommendation som väntar på svar: testa vila **medvetet och kort**
  (stäng locket ~10 sek och öppna igen, redo att nödstoppa) innan man
  litar på det, ELLER inaktivera `systemctl suspend`-regeln i hypridle
  som säkerhetsåtgärd tills det är bekräftat. Se
  [[../03-felsokning/s2idle-vaknar-aldrig]].

## Löst (kvar som referens en kort tid)

- ~~Strömknappen syns inte/gör inget~~ — **löst och bekräftat 2026-09-16.**
  `linux-surface` exponerade en ny `gpio-keys`-enhet med `KEY_POWER` (se
  [[../03-felsokning/strömknapp-syns-inte]]), `systemd-logind` bevakar den
  nu, och Jakob bekräftade live: kort tryck fungerar. Hela kedjan
  (`hypr/keybinds.lua` → `XF86PowerOff` → wlogout, plus
  `logind.conf.d/power-button.conf` för kort/lång särskiljning) är nu
  verifierad i praktiken, inte bara i teorin.

- ~~wallust AUR-bygge (checksummefel)~~ — löst 2026-09-15,
  `updpkgsums && makepkg -si` i `~/.cache/yay/wallust`.
- ~~Dynamiskt wallust-tema inte aktiverat~~ — löst 2026-09-15, aktiverat live
  (`wallpaper-cycle.timer` kör nu, klockstyrt varje heltimme).
- ~~`linux-surface` inte installerad~~ — löst 2026-09-16, Jakob installerade
  själv. Kör `6.19.8-arch1-3-surface`, `surface_aggregator`+HID-moduler
  laddade, `acpi_osi="Windows 2022"` + `pci=hpiosize=0` i cmdline bekräftat.
  Se [[linux-surface-installation]] och [[../02-beslut/changelog]].
