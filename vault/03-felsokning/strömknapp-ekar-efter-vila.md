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

## Fix, försök 1 (2026-09-18, misslyckades)

En kylningsperiod: `after_sleep_cmd` skrev en tidsstämpel efter
uppvaknande, och `power-button.sh` jämförde nuvarande tid mot den — under
3 sekunder sedan uppvaknandet antogs vara ett eko.

**Fungerade inte.** Jakob testade: "samma problem som innan. datorn
tolkade det som att jag klickade på power knappen när jag skulle ut."
Orsak: **kapplöpning**. Eko-tangenttryckningen kan nå Hyprland (och
trigga `power-button.sh`) innan `hypridle` hinner köra sitt
`after_sleep_cmd` och skriva tidsstämpeln — då finns ingen färsk
tidsstämpel att jämföra mot, och trycket filtreras inte bort.

## Fix, försök 2 (2026-09-18) — markörfil, ingen tidsjämförelse

Vände på ordningen för att helt undvika kapplöpningen: `before_sleep_cmd`
**armar** en markörfil (`~/.cache/power-button-wake-pending`) *innan*
datorn somnar — det körs garanterat klart innan suspend faktiskt sker,
ingen race möjlig där. `power-button.sh` kollar bara om markören
**finns**, ingen tidsjämförelse: finns den, konsumeras den (tas bort) och
trycket ignoreras, oavsett hur snabbt eller långsamt eko-trycket kommer.

Kvarstående edge-case: om datorn väcks med tangentbord/mus istället för
strömknappen konsumeras aldrig markören av ett eko, och skulle annars
ligga kvar och felaktigt blockera en äkta knapptryckning långt senare.
Löst med `after_sleep_cmd`: städar bort markören 5 sekunder efter
uppvaknande om inget eko hunnit konsumera den själv.

## Verifiering kvar

Inte testat live än (kräver en riktig vila/uppvaknande-cykel + ett kort
tryck direkt efter). Se [[../05-todo/vantar-pa-jakob]] om något behöver
bekräftas av Jakob.
