# Tangentbordsbelysningen släcks efter ~20 sekunder — känd begränsning, inte fixbar

## Vad Jakob märkte

Tangentbordets bakgrundsbelysta knappar slocknar efter bara ~20 sekunders
inaktivitet, och han ville ha den tänd längre.

## Undersökt 2026-09-18 — inget att justera

- Ingen tangentbordsbelysning syns som en styrbar enhet i Linux alls:
  `/sys/class/leds/` innehåller bara `input19::capslock`/`numlock`/
  `scrolllock` och `phy0-led` (wifi) — ingen `kbd_backlight`-post.
  `brightnessctl --list` visar samma sak: bara `intel_backlight`
  (skärmen) och lås-lamporna.
- Kollade `linux-surface`-projektets officiella funktionsmatris
  (Supported-Devices-and-Features-wikin): tangentbordsbelysning finns
  **inte ens listad** som en spårad funktion för någon Surface-modell —
  varken som "stöds" eller "stöds inte".

## Slutsats

Tidsgränsen (~20 sek) styrs helt av Surface-hårdvarans inbyggda
styrenhet (samma EC/SAM-lager som strömknappen och vilan hanterades av
innan [[../02-beslut/changelog|linux-surface installerades]]), utan något
gränssnitt operativsystemet kan se eller justera. Sannolikt identiskt,
icke-konfigurerbart beteende på Windows också.

**Ingen åtgärd möjlig just nu** — inte upptagen som en todo/väntar-punkt,
det finns inget att vänta på eller bygga. Enda tänkbara vägen skulle vara
en feature-request mot `linux-surface`-projektet själva, om Jakob någon
gång vill driva det.
