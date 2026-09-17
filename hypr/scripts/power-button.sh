#!/usr/bin/env bash
# Strömknappen genererar en "eko"-tangenttryckning direkt efter att den
# väckt datorn ur vila (samma fysiska tryck syns både som väck-signal och
# som en vanlig KEY_POWER-händelse när input-systemet är igång igen) - utan
# det här filtret öppnas wlogout-menyn direkt varje gång man väcker datorn.
# Se vault/03-felsokning/strömknapp-ekar-efter-vila.md.
#
# hypridles after_sleep_cmd (hypridle.conf) skriver en tidsstämpel hit vid
# varje uppvaknande - om strömknappen trycks inom kort tid efter det,
# anta att det är samma fysiska tryck som ekar, inte en ny avsiktlig
# tryckning.
RESUME_FILE="$HOME/.cache/last-resume-time"
COOLDOWN=3

now=$(date +%s)
last_resume=0
[ -f "$RESUME_FILE" ] && last_resume=$(cat "$RESUME_FILE" 2>/dev/null || echo 0)
elapsed=$(( now - last_resume ))

if [ "$elapsed" -lt "$COOLDOWN" ]; then
    exit 0
fi

exec wlogout -b 5 -l ~/.config/wlogout/layout.json -C ~/.config/wlogout/style.css
