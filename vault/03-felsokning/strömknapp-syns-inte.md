# Strömknappen finns inte som input-enhet alls (Surface Laptop 6)

## Vad hände

Testade strömknappsfixen ([[logind-omstart-svart-skarm]],
[[../02-beslut/changelog]]) med ett kort tryck. Ingenting hände —
varken wlogout-menyn öppnades eller något annat.

## Orsak

```
$ ls /sys/bus/acpi/devices/ | grep PNP0C0
PNP0C0B:00
PNP0C0D:00
```

`PNP0C0D` = Lid Switch (locket, finns). **`PNP0C0C` = ACPI:s standard-ID
för en strömknapp — finns inte alls.** Bekräftat även i
`/proc/bus/input/devices`: ingen "Power Button"-post någonstans, bara
"Lid Switch". Ingen `evtest`/`libinput` var installerat för djupare
diagnostik, men ACPI-enhetslistan är entydig nog på egen hand.

Konsekvens: strömknappen ger **ingen som helst input-händelse** som
`systemd-logind` eller Hyprland (via libinput/Wayland) kan se. Varken min
`hypr/keybinds.lua`-keybind (`XF86PowerOff`) eller
`logind.conf.d/power-button.conf` (`HandlePowerKey=ignore`) kan alltså
någonsin trigga — det finns inget att fånga.

## Det ändrar den tidigare diagnosen

Jag skrev tidigare (se [[../02-beslut/changelog]], strömknappen-stänger-av-
direkt-buggen) att `systemd-logind`s `HandlePowerKey=poweroff`-förval var
orsaken till att datorn stängdes av direkt vid ett kort tryck. **Det kan
inte stämma** om logind aldrig ser knappen via en normal input-enhet.
Det som faktiskt stängde av datorn måste ha skett på en lägre nivå —
firmware/embedded controller (EC), utanför vad Linux normalt ser eller kan
konfigurera via `logind.conf`. Sannolikt samma bakomliggande lager som
orsakar `s2idle`-uppvaknandeproblemet (se [[hyprpaper-current-symlink-saknades]]
för den dagen i stort).

## Trolig fix

Surface-hårdvarans strömknapp (och mycket annan strömhantering) routas via
Microsofts "Surface Aggregator Module" (SAM), som kräver
Surface-specifika kärndrivrutiner (`surface_aggregator`,
`surface_aggregator_registry`, `surface_hid` m.fl., ingår i
`linux-surface`-kärnan) för att exponeras som normala Linux-input-enheter.
Utan dem är strömknappen (och sannolikt flera andra Surface-specifika
funktioner) osynlig för både `systemd-logind` och Hyprland — ingen mängd
config i den här dotfiles-repot kan komma runt det.

Se [[../05-todo/vantar-pa-jakob]] — `linux-surface`-installationen är nu
den gemensamma boven bakom både detta och `s2idle`-uppvaknandeproblemet.
Jakob har sagt att han vill titta på det "senare", inte påbörjat.

## Löst 2026-09-16

Jakob installerade `linux-surface` själv (kärna `6.19.8-arch1-3-surface`).
Efter det:

```
$ lsmod | grep surface
surface_aggregator, surface_hid, surface_hid_core,
surface_aggregator_registry, surface_platform_profile,
surface_battery, surface_charger, surface_fan, surface_temp, ...
```

En ny input-enhet dök upp som inte fanns med den vanliga kärnan:

```
N: Name="gpio-keys"
S: Sysfs=.../MSHW0040:00/gpio-keys.2.auto/input/input2
B: KEY=10000000000000 0    <- avkodat: KEY_POWER (116)
```

`systemd-logind` loggade direkt `Watching system buttons on
/dev/input/event2 (gpio-keys)`, och `hyprctl binds` visade
`XF86PowerOff`-keybinden fortfarande registrerad. Jakob bekräftade sedan
live: **ett kort tryck fungerar nu** (öppnar wlogout-menyn). Hela
`vantar-pa-jakob`-punkten om strömknappen är struken.

En bonusenhet (`gpio-keys` #1) exponerade samtidigt volym upp/ner som
riktiga knappar — fanns inte heller innan.

Se [[s2idle-vaknar-aldrig]] — det närbesläktade suspend/vila-problemet är
**inte** verifierat löst av samma kärnbyte, uttryckligen inte rört av
Jakob än.
