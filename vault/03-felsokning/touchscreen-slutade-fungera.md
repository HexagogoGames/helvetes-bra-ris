# Pekskärmen slutade fungera efter bytet till linux-surface — känt, olöst uppströms

## Vad Jakob märkte

"efter jag bytta till linux-surface. min touch skärm funkar inte längre.
förrut kunde jag med fingrarna styra på skärmen."

## Undersökt 2026-09-18

Hårdvaran/drivrutinsstacken ser i övrigt frisk ut:

- `iptsd@dev-hidraw0.service` kör (`Running in Touchscreen mode`, ingen
  krasch, inga fel efter start).
- Både rå (`quickspi-hid-045e:0c88-touchscreen`) och bearbetad
  (`iptsd-virtual-touchscreen-045e:0c88`) touch-enhet syns för Hyprland
  (`hyprctl devices`).
- `input.lua`/`rules.lua` har inga regler som stänger av touch.

Men kärnloggen från exakt samma sekund kärnan bytte (`journalctl -k -b 0`)
visar: `intel_quickspi 0000:00:10.0: Wrong input report length: 15` —
ett fel i själva HID-transportlagret som läser rådata från pekpanelen,
**innan** iptsd ens får chansen att tolka något. Kollade
`/etc/iptsd.conf`: `ActivationThreshold`/`DeactivationThreshold` ligger
redan på de "återställ till standard"-värden (24/20) som en näraliggande
känslighetsbugg i iptsd föreslog som fix för andra Surface-modeller — så
det är inte en känslighetsinställning som är fel här, felet sitter lägre
ner än vad en iptsd-configändring kan påverka.

## Känt, olöst uppströms

[linux-surface/linux-surface#1747](https://github.com/linux-surface/linux-surface/issues/1747)
— "Touchscreen not working on Surface Laptop 6 (Intel) after
6.14.2-surface update", öppnat april 2025, **fortfarande öppet**. Exakt
samma modell och symptom (fungerade innan, helt orespons efter en
surface-kärnuppdatering). Ingen bekräftad fix i tråden. Jakobs specifika
felrad (`Wrong input report length: 15`) nämns inte där — skulle kunna
vara värdefull information att lägga till om han vill kommentera ärendet,
men löser inget själv.

## Status

**Ingen åtgärd möjlig från vår sida just nu** — det här är ett
kärndrivrutinsfel i `linux-surface`-projektet, inte något i dotfiles-
configen. Inte en todo/väntar-punkt, samma kategori som
[[tangentbordsbelysning-tidsgrans]]: inget att vänta på eller bygga,
bara att hålla koll på om projektet släpper en fix i en framtida
`linux-surface`-uppdatering.
