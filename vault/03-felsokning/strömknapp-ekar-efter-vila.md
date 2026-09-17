# Strömknappen öppnar wlogout-menyn direkt efter att ha väckt datorn

## Vad hände

Jakob: "jag klickar på power knappen för att starta upp datorn från
sleep. det funkar nu bra. men när jag loggat in så får jag upp
'stäng av menyn'... men jag vill använda power knappen för att väcka
datorn."

## Orsak

Samma fysiska knapptryckning gör dubbel nytta: den väcker datorn ur
`s2idle`-vila (se [[s2idle-vaknar-aldrig]]) **och** syns sedan som en
vanlig `KEY_POWER`-händelse så fort input-systemet är igång igen efter
uppvaknandet. Hyprlands `XF86PowerOff`-keybind (öppnar wlogout, se
[[../02-beslut/changelog]] 2026-09-15/16) kan inte skilja på "det här
trycket väckte mig" och "det här är ett nytt, avsiktligt tryck" — båda ser
identiska ut för keybinden.

## Fix

En liten kylningsperiod. `hypr/hypridle.conf`s `after_sleep_cmd` skriver nu
en tidsstämpel till `~/.cache/last-resume-time` varje gång datorn vaknar.
Keybinden pekar inte längre direkt på `wlogout`, utan på ett nytt skript
(`hypr/scripts/power-button.sh`) som jämför nuvarande tid mot den
tidsstämpeln: om det är **under 3 sekunder** sedan senaste uppvaknandet,
antas trycket vara samma fysiska eko och ignoreras. Annars öppnas
wlogout-menyn precis som vanligt.

## Verifiering kvar

Inte testat live än (kräver en riktig vila/uppvaknande-cykel + ett kort
tryck direkt efter). Se [[../05-todo/vantar-pa-jakob]] om något behöver
bekräftas av Jakob.
