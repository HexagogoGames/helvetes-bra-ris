# `s2idle`-viloläget vaknar inte (Surface Laptop 6)

## Vad hände (två separata tillfällen, samma mönster)

- **2026-09-15, 06:40:45**: `systemd-logind: Lid closed. Suspending...` →
  kärnan gick in i `s2idle`. Vaknade aldrig — total låsning, inga
  lampor/fläktar. Krävde 20-30 sek intryckt strömknapp för att hård-resetta.
- **2026-09-15, 23:02:48**: exakt samma sak, återigen `Lid closed.
  Suspending...`, återigen ingen ordinarie uppstart förrän ~21 timmar
  senare via samma tvingade hård-reset.

Bekräftat i loggen båda gångerna (`journalctl --list-boots` visar tydliga
hopp i tid mellan när en boot slutar och nästa börjar, med
`kernel: PM: suspend entry (s2idle)` som sista meningsfulla rad innan
tystnaden).

## Ytterligare upptäckt: inte bara locket

`~/.config/hypr/hypridle.conf` har en oberoende regel:
```
listener {
    timeout = 900
    on-timeout = systemctl suspend
}
```
(Uppdaterad 2026-09-16 till `timeout = 1200`/20 min på Jakobs begäran, i
samband med att dimma/lås/skärm-av också fick längre tider — se
[[../02-beslut/changelog]]. Ändrar inget i sak: samma `systemctl suspend`,
samma osäkra uppvakning.)
Datorn somnar automatiskt (samma trasiga `s2idle`) efter **20 minuters
inaktivitet**, helt oavsett om locket är öppet eller stängt. Det gör det
här till ett systematiskt, garanterat återkommande problem — inte ett
sällsynt edge-case.

## Orsak (troligen)

`/sys/power/mem_sleep` visar att hårdvaran/firmware **bara erbjuder
`s2idle`** — inget riktigt `deep`/S3-viloläge finns att växla till som
alternativ kärnparameter. `/proc/acpi/wakeup` saknar helt registrerade
väck-källor för lock eller knapp, både med vanlig `linux`-kärna och (ännu,
overifierat) med `linux-surface`. Se [[strömknapp-syns-inte]] för det
närbesläktade fyndet att strömknappen inte syntes för mjukvaran alls innan
`linux-surface` installerades — sannolikt samma bakomliggande brist på
korrekt EC/SAM-integration.

## Status 2026-09-16

Jakob installerade `linux-surface` (se [[../02-beslut/changelog]]), vilket
löste det närbesläktade strömknappsproblemet (bekräftat live). **Men
suspend/vila-problemet är explicit INTE testat eller åtgärdat** — Jakobs
egna ord: "jag har inte rört suspend/vila problemet". `hypridle`s
15-minutersregel för auto-vila är fortfarande aktiv. `/proc/acpi/wakeup`
visar fortfarande inga väck-källor även med den nya kärnan (kan bero på
att `surface_aggregator` sköter det utanför den generiska ACPI-listan —
eller inte, okänt).

**Rör inte det här oövervakat.** Rekommendation som väntar på svar: testa
vila medvetet och kort (stäng locket ~10 sekunder, öppna igen, redo att
nödstoppa om det inte vaknar) innan man litar på det, eller inaktivera
`systemctl suspend`-regeln i hypridle som säkerhetsåtgärd tills det är
bekräftat. Se [[../05-todo/vantar-pa-jakob]].
