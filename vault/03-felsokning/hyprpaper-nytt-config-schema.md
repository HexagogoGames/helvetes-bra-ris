# hyprpaper: nytt config-schema (upptäckt 2026-09-14)

## Problem

`hyprpaper.conf` skriven med den klassiska, överallt dokumenterade syntaxen:

```
preload = /path/to/image.png
wallpaper = eDP-1,/path/to/image.png
splash = false
ipc = on
```

gav ingen wallpaper alls — skärmen förblev svart. Loggen (`hyprpaper --verbose`)
visade aldrig något om att config-filen ens lästes, och slutade med:

```
Monitor eDP-1 has no target: no wp will be created
```

`hyprctl hyprpaper preload/wallpaper`-IPC-kommandona (den vanliga reservlösningen)
gav också `error: invalid hyprpaper request`.

## Orsak

Den installerade `hyprpaper`-versionen (`0.8.4-8` i Arch-repona) är byggd mot
**hyprtoolkit** (syns i `ldd`/loggarna) — en nyare ombyggnad som bytt config-schema
helt, utan att versionsnumret signalerar det. `strings` på binären avslöjade en
`CWallpaperMatcher`/`SMonitorState`-klass och nyckelorden `monitor`, `target`,
`name`, `cover`, `contain` — inga träffar alls på `preload`/`wallpaper` som
toppnivå-nycklar.

Hämtade den faktiska källkoden (`ConfigManager.cpp` på GitHub) för att bekräfta
rätt schema: `wallpaper` är numera en **special category** (samma mekanism som
Hyprlands `device { }`-block för indata), med `monitor` som nyckelfält:

```
splash = 0
ipc = 1

wallpaper {
    monitor = eDP-1
    path = /home/jakob/dotfiles/images/backgrounds/forrest-background1.png
    fit_mode = cover
}
```

Efter detta försvann felmeddelandet, loggen visade `layer: got fractional scale`
+ `configure layer`, och en skärmdump bekräftade att bilden faktiskt syns.

## Lärdom

Om ett Hypr-ekosystem-verktyg beter sig som om configen inte läses alls (inga
parse-loggar, ingen felrapport heller) — misstänk att paketversionen är nyare än
den vanliga dokumentationen/de vanliga exemplen man hittar, inte att syntaxen är
felstavad. `strings <binär>` + källkoden på GitHub (`ConfigManager.cpp`) är
snabbare än att gissa sig fram rad för rad.

Se [[../04-tema/design]] för wallpaper-beslutet i stort.
