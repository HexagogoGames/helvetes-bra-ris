# Låsskärmen (hyprlock) hade svart bakgrund istället för bilden

## Vad hände

Jakob: "jag tror något är fel med lock screen. bakgrunden blir helt
svart där. det skulle det inte vara."

## Orsak

`hypr/hyprlock.conf`s `background { path = ... }` pekade fortfarande på
`images/backgrounds/forrest-background1.png` — Jakobs ursprungliga
wallpaper-val från temaomdesignen (se [[../04-tema/design]]), som han
själv tog bort för länge sen ("jag tog bort forrest background1 för den
var inte min", se [[../02-beslut/changelog]] 2026-09-15). Ingen fil på den
sökvägen → hyprlock renderar ingenting → svart. Missades när
`hyprpaper.conf` fick sin egen fix för samma sorts problem tidigare
([[hyprpaper-current-symlink-saknades]]) eftersom hyprlock är en helt
separat config-fil.

## Fix

Ändrade `path` till samma stabila symlink som `hyprpaper.conf` redan
använder: `images/backgrounds/.current.jpg`. Uppdateras automatiskt av
`hypr/scripts/wallpaper-cycle.sh` vid varje bakgrundsbyte (se
[[../04-tema/dynamiskt-tema]]) — låsskärmen visar nu alltid samma bild som
skrivbordet, och kan inte peka på en borttagen fil igen.

## Lärdom

När en bakgrundsbild byts ut eller tas bort, kom ihåg att **både**
`hyprpaper.conf` **och** `hyprlock.conf` refererar till bildfiler separat
— en sökväg som fixas i den ena missas lätt i den andra om man inte
grep:ar igenom hela repot efter filnamnet.
