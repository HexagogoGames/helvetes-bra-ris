# hyprpaper: nytt config-schema (upptäckt 2026-09-14, utökad 2026-09-15)

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

## Bonus-fynd 2026-09-15: inbyggt bildspel

Samma ombyggnad har ett fält till som inte är dokumenterat någonstans:
`path` kan peka på en **mapp** istället för en enskild fil. Bekräftat i
källkoden (`src/ui/UI.cpp`): om fler än en bild matchar skapas en
`CImagesData` + en timer (`onRepeatTimer`) som växlar bild var
`timeout`-sekund. Extra fält i `wallpaper { }`: `timeout` (sekunder,
standard 30 om `path` är en mapp med flera bilder), `order`
(`default`/`random`/`random-shuffle`), `recursive` (skanna undermappar).

```
wallpaper {
    monitor = eDP-1
    path = /home/jakob/dotfiles/images/backgrounds
    fit_mode = cover
    timeout = 1200
    order = default
}
```

## Lärdom

Om ett Hypr-ekosystem-verktyg beter sig som om configen inte läses alls (inga
parse-loggar, ingen felrapport heller) — misstänk att paketversionen är nyare än
den vanliga dokumentationen/de vanliga exemplen man hittar, inte att syntaxen är
felstavad. `strings <binär>` + källkoden på GitHub (`ConfigManager.cpp`) är
snabbare än att gissa sig fram rad för rad.

Se [[../04-tema/design]] för wallpaper-beslutet i stort.

## Bugg 2026-09-15: svart bakgrund efter namnbyte av bildfiler live

Döpte om `vårskog-1..4.jpg` → `höstskog-1..4.jpg` i `images/backgrounds/`
medan hyprpaper redan kördes med den mappen i bildspelet. Bakgrunden blev
helsvart efter nästa bildväxling.

**Orsak** (bekräftat i `src/ui/UI.cpp`): katalogens filnamn läses in **en
gång** vid start till en fast vektor (`CWallpaperTarget::CImagesData::images`)
— det finns ingen omskanning. När timern (`onRepeatTimer`) växlar till ett
cachat, nu icke-existerande filnamn misslyckas bildladdningen tyst, och det
enda som syns är en hårdkodad svart bakgrundsrektangel (`m_bg`,
`0xFF000000`) som annars ligger dold bakom bilden.

**Fix:** starta om hyprpaper (`pkill -x hyprpaper; hyprpaper &`) så mappen
skannas om från grunden.

**Lärdom:** döp aldrig om eller ta bort filer i `images/backgrounds/` medan
hyprpaper kör utan att starta om den direkt efteråt — annars pekar den
cachade bildlistan förr eller senare på en fil som inte längre finns.
