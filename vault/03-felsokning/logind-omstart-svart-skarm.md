# `systemctl restart systemd-logind` gav svart skärm med blinkande markör

## Vad hände

Jakob körde de tre kommandona för strömknappsfixen (se
[[../02-beslut/changelog]] 2026-09-15). Efter det sista
(`sudo systemctl restart systemd-logind`) blev skärmen svart med en
blinkande `_` uppe till vänster. Han loggade in på en textkonsol och körde
`reboot` själv för att komma tillbaka — en ren, kontrollerad omstart, ingen
krasch, ingen dataförlust.

## Orsak (bekräftat i journalctl)

Jag sa till Jakob att omstart av `systemd-logind` "brukar vara ofarligt
(loggar inte ut dig)" — **det var fel av mig.** `systemd-logind` äger
seat-/sessionshantering och vem som får DRM-master (rätten att rita på
skärmen). Att döda och starta om den processen medan en grafisk session
redan äger seatet river sönder den sessionen:

```
22:24:06  sudo[...]: COMMAND=/usr/bin/systemctl restart systemd-logind
22:24:07  systemd-logind[14328]: New seat seat0.
22:24:07  systemd-logind[14328]: New session '5' of user 'gdm-greeter' ...
22:24:23  systemd[14408]: Reached target Shutdown running GNOME Session.
22:25:53  systemd-logind[14328]: New session '7' of user 'jakob' ... type 'tty'
22:29:35  systemd-logind[14328]: reboot requested from client PID 19629
          ('reboot') (unit user@1000.service)...
```

GDM:s greeter-session startade om som en direkt bieffekt av den nya
logind-instansen, vilket i sin tur slog ut den aktiva Hyprland-sessionen.
Jakob loggade in via TTY (session 7) och körde `reboot` manuellt fem minuter
senare — inte en automatisk krasch, ett medvetet val för att komma tillbaka
snabbast.

## Lärdom

**Ändra aldrig `logind.conf`/`logind.conf.d/*` och kör sedan
`systemctl restart systemd-logind` live i en aktiv grafisk session.**
Rätt tillvägagångssätt: lägg ändringen på plats, be användaren starta om
hela datorn på vanligt sätt (`reboot`/menyn) istället för att döda
logind-processen för sig. Konfigurationen läses in av en helt ny
logind-instans vid nästa riktiga omstart utan att sessionen någonsin
behöver rivas sönder mitt i.

Bekräftat i efterhand: config-filen låg redan rätt (`tee` hade redan
skrivit den innan omstarten skulle behövas alls), så själva
`systemctl restart`-steget var **onödigt** — nästa ordinarie omstart hade
räckt. Se [[../05-todo/vantar-pa-jakob]].
