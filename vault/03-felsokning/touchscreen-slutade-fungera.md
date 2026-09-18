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

## Vad felet faktiskt betyder (källkoden läst 2026-09-18)

Drivrutinen är **mainline Linux**, inte `linux-surface`-specifik kod:
`drivers/hid/intel-thc-hid/intel-quickspi/quickspi-protocol.c` i
`torvalds/linux`. Den exakta raden (`quickspi_handle_input_data`):

```c
input_len = le16_to_cpu(body_hdr->content_len);

if (HIDSPI_INPUT_BODY_SIZE(input_len) > buf_len) {
    dev_err_once(qsdev->dev, "Wrong input report length: %u", input_len);
    return;
}
```

Touchkontrollern skickar ett paket över SPI-bussen och deklarerar hur
mycket nyttolast det innehåller (`content_len`, hos oss 15). Drivrutinen
jämför det mot hur mycket data som faktiskt kom in i DMA-bufferten
(`buf_len`) — om den deklarerade storleken inte får plats, kastas hela
paketet utan vidare bearbetning. Eftersom `dev_err_once` bara loggar en
gång, vet vi inte om det händer för varje beröring eller bara vid start —
men eftersom touch inte fungerar alls är det troligt att det är varje
gång.

## Vad ett riktigt fix skulle kräva

1. Lägg till egen loggning av **både** `input_len` (deklarerad) och
   `buf_len` (faktisk) på felraden - vi vet just nu bara den ena.
2. Bygg om just den kärnmodulen, ladda den, reproducera (rör pekskärmen),
   läs loggen.
3. Bilda en hypotes utifrån den faktiska skillnaden (kapplöpningstillstånd
   i DMA-kompletteringen? fel buffertstorlek beräknad någon annanstans i
   `pci-quickspi.c`? en firmware-kvirk specifik för den här pekpanelen?).
4. Implementera, bygg om, testa - troligen flera varv.
5. Om det fungerar: en riktig kärnpatch via mejl till HID-underhållarnas
   lista (inte en vanlig GitHub-PR, eftersom det är mainline-kärnan),
   kräver ett riktigt namn i en `Signed-off-by`-rad (kärnans DCO-regel).

## Status

Jakob tyckte idén (fixa på riktigt + skicka patch uppströms) lät kul, men
ville inte börja direkt 2026-09-18 — realistiskt timmar av iterativ
felsökning. Sparad som ett riktigt projekt i [[../05-todo/wishlist]] för
när han har tid avsatt. Inte en `vantar-pa-jakob`-punkt (inget som väntar
på ett snabbt beslut/kommando) — se även [[tangentbordsbelysning-tidsgrans]]
för samma "känd begränsning, ingen enkel fix"-kategori.
