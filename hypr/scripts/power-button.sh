#!/usr/bin/env bash
# Strömknappen genererar en "eko"-tangenttryckning direkt efter att den
# väckt datorn ur vila - filtrerar bort det här. Se
# vault/03-felsokning/strömknapp-ekar-efter-vila.md.
#
# hypridles before_sleep_cmd "armar" en markörfil INNAN varje vila
# (garanterat ingen kapplöpning - det körs alltid klart innan datorn
# faktiskt somnar). Om markören finns när strömknappen trycks antas det
# vara samma fysiska tryck som just väckte datorn - ingen tidsjämförelse
# behövs, bara närvaro/frånvaro. (Ett tidigare försök jämförde istället
# en tidsstämpel skriven EFTER uppvaknandet - det racade mot eko-trycket
# och fungerade inte tillförlitligt.)
#
# after_sleep_cmd städar bort markören efter 5 sek om ingen
# eko-tryckning konsumerar den (t.ex. om datorn väcktes med
# tangentbord/mus istället) - annars skulle en äkta knapptryckning långt
# senare kunna bli felaktigt blockerad av en kvarglömd markör.
MARKER="$HOME/.cache/power-button-wake-pending"

if [ -f "$MARKER" ]; then
    rm -f "$MARKER"
    exit 0
fi

exec wlogout -b 5 -l ~/.config/wlogout/layout.json -C ~/.config/wlogout/style.css
