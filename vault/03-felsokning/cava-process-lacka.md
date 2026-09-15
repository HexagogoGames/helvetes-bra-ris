# cava-processer läckte vid varje waybar-omstart (2026-09-15)

## Vad Jakob märkte

"Det står 12% GPU nu. Är det mycket? För att bara vara i desktop?" — bad om en
generell resurs-felsökning, inte bara ett svar på GPU-frågan.

## Vad som hittades

**22 st `cava`-processer** körde samtidigt, varav bara 2 hörde till den
faktiska, levande waybar-instansen. Resten var föräldralösa — kvarlämnade
efter upprepade `pkill waybar; waybar &`-omstarter tidigare under kvällens
tema-arbete (många omstarter för att testa waybar-CSS-ändringar).

**Orsak:** `waybar/scripts/cava-waybar.sh` körs som en strömmande
`custom/cava`-modul (`cava -p ... | while read ...; do ...; done`) som waybar
startar en gång och sedan läser kontinuerligt från. När waybar dödas
(`pkill waybar`) dör bara waybar-processen — `cava-waybar.sh` och dess
`cava`-barn är inte riktiga barnprocesser till waybar på ett sätt som gör att
de dör med den; de blir kvar, adopterade av `init` (pid 1), och fortsätter
köra för evigt i bakgrunden. Varje ny waybar-start (manuell omstart, eller via
`Super+Shift+R`-genvägen i `keybinds.lua`) lägger till **ännu en** utan att ta
bort den gamla.

Detta är inget engångsfel av mig i den här sessionen — **samma sak händer
varje gång waybar startas om**, inklusive när Jakob själv gör det via
`Super+Shift+R`.

## Fix

`cava-waybar.sh` dödar nu sina egna gamla instanser (matchat på skriptets
fulla sökväg) samt alla `cava -p .../waybar.conf`-processer innan den startar
en ny. Testat: 3 omstarter av waybar i rad, exakt en ren instans kvar varje
gång (inte en växande hög).

## Lärdom

En strömmande waybar-`custom`-modul (exec som aldrig avslutar, bara pipar
kontinuerligt) behöver städa upp efter sig själv vid start — waybar
garanterar inte att döda den vid omstart.

**Uppföljning samma dag:** Jakob bad om en fullständig genomgång av allt som
skulle kunna läcka på samma sätt. Hittade två till skript med exakt samma
sårbarhetsmönster (strömmande/oändlig bakgrundsloop som inte städar sig
själv):

- `hypr/scripts/wob-init.sh` — `tail -f wob.sock | wob` (samma
  pipe-mönster som cava). Visade sig dessutom vara **helt död** vid
  granskningen (ingen process läste från pipen längre — volym-/
  ljusstyrke-OSD:n visade alltså ingenting), troligen dödad under
  kvällens testande utan att startas om igen.
- `hypr/scripts/ac-sound-watch.sh` — `while true; do sleep 1; ...; done`,
  spelar ljud vid in-/urkoppling av laddaren. Bara en instans körde vid
  granskningen, men samma latenta risk: två samtidiga instanser hade spelat
  varje ljud dubbelt.

Båda fick samma self-cleanup-tillägg som `cava-waybar.sh` (döda gamla
instanser av sig själv/sin pipe-partner innan start). `wob` omstartad och
verifierad fungerande igen (skärmdump av OSD-stapeln vid volymändring).

Övriga `custom`-moduler (`custom/gpu`, `custom/systemstats`) kör som vanliga
interval-baserade `exec` som avslutar varje gång, inte strömmande — inte
samma risk. Ingen ytterligare läcka hittad i en bredare processgenomgång
(inga dubbletter av waybar/eww/swaync/hyprpaper, inga zombies, minnet
dominerat av Firefox/VS Code/Claude, inte riggen).

Se [[../02-beslut/changelog]] för åtgärden i stort.
