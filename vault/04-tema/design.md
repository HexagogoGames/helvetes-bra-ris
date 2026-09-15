# Tema / design

## 🚧 Temaomdesign pågår (påbörjad 2026-09-14)

Allt under "Tidigare placeholder-tema" nedan var provisoriskt — Jakob bestämde
2026-09-14 att designen ska tas om från grunden, medvetet, del för del. Använde
[[../05-todo/temaverkstad|Riggsmedjan]] (interaktiv Artifact, källa:
`vault/05-todo/temaverkstad.html`) för att utforska estetik/färg/mättnad live innan
beslut.

### Beslutat hittills

**Estetik: Glassy** (bytt från Vibrant 2026-09-14, allt annat i den här filen
opåverkat). Blur bakom paneler/fönster, halvgenomskinliga ytor, mjukt rundade hörn.
`rounding = 18px`, `border_size = 1`, `gaps_in = 8` / `gaps_out = 14`, blur på
(`size = 8`, `passes = 3`), `active_opacity = 0.92` / `inactive_opacity = 0.62`.
Ingen gradient-kant (se beslut nedan, oberoende av estetik-val) — bara solid
accentfärgad kant.

**Färgschema: bytt från Gruvbox Dark → egen palett, officiellt döpt "Svensk
skog"** (2026-09-14/15). Jakob la in sin egen wallpaper
(`images/backgrounds/forrest background1.avif`, konverterad till PNG eftersom
hyprpaper inte länkar mot libavif) och bad om en mörkgrön/genomskinlig palett
som matchar bilden. Extraherade riktiga dominant-färger ur fotot
(`magick ... -colors 12 -unique-colors`) istället för att gissa gröna toner.

**Fullständig, officiell referens: [[svensk-skog-palett]]** — hex-tabell,
border-regeln (grön kant men guld/löv-fyllningar), var den används, och att
det mesta framöver ska matcha den (t.ex. det planerade Spicetify-temat, se
[[../05-todo/wishlist]]).

`col.active_border = rgba(3f5c42ff)`, `col.inactive_border = rgba(93a08c33)`.
Gruvbox-planen (inkl. btop community-temat) är överspelad — se implementationsloggen
nedan.

**Wallpaper:** klart. `hyprpaper` (ersatte `swaybg` i `autostart.lua`), config i
`hypr/hyprpaper.conf`, bild `images/backgrounds/forrest-background1.png` (Jakobs eget
val, konverterad från `.avif`).

**Läge: Mörkt.**

**Färgschema: Gruvbox Dark.**

| Roll | Hex | Källa |
|---|---|---|
| Bakgrund | `#282828` | Gruvbox Dark bg |
| Yta (paneler/fönster) | `#3c3836` | Gruvbox Dark bg1 |
| Text | `#ebdbb2` | Gruvbox Dark fg |
| Text (dämpad) | `#a89984` | Gruvbox Dark gray |
| Accent 1 (aktiv kant, highlights) | `#fe8019` | Gruvbox orange |
| Accent 2 (sekundär, t.ex. gradient-kant) | `#83a598` | Gruvbox blue/aqua |
| Röd (varning/låg batteri) | `#fb4934` | Gruvbox red |

`col.active_border = rgba(fe8019ff)`, `col.inactive_border = rgba(a8998433)` (fgDim
med låg alfa).

**Mättnad:** antaget Medel (standardläget i Riggsmedjan, rördes inte explicit) —
**dubbelkolla med Jakob.**

**Typografi:** IBM Plex Mono överallt (UI + terminal, samma font). Textstorlek
medel: waybar `13px`, kitty `12.0pt`. Inga ligaturer (fonten saknar dem). Ikonstil:
glyf-ikoner i textflödet, som redan är konventionen i waybar.

```
/* waybar/style.css */
* { font-family: "IBM Plex Mono", monospace; font-size: 13px; }
```
```
# kitty.conf
font_family      IBM Plex Mono
font_size        12.0
```

**Waybar-layout:** panel i **toppen**, moduler grupperade i **kapslar** (rundad
bakgrund per zon: `.modules-left`/`.modules-center`/`.modules-right`). Workspace-stil:
**punkter** (inga siffror — fyllda/tomma prickar). Moduler: `cava`, `custom/gpu`,
`network`, `battery`, `custom/power-profile` (befintliga) + **`custom/mpris` tillagd**
(media-widget, ny). `custom/tray`/väder inte tillagda.

```
// waybar/config.jsonc
{
    "layer": "top",
    "position": "top",
    "modules-left": ["hyprland/workspaces", "custom/dotfiles"],
    "modules-center": ["cava", "custom/gpu", "custom/mpris"],
    "modules-right": ["network", "battery", "custom/power-profile", "clock"]
}
```
```
/* style.css */
"hyprland/workspaces" { /* punkt-stil, inga siffror */ }
.modules-left, .modules-center, .modules-right {
    background: alpha(@fg, 0.07);
    border-radius: 8px;
    padding: 2px 10px;
}
```

**Gradient-kant:** avfärdad. Bara enkel solid accentfärgad kant
(`col.active_border = fe8019`, redan i runda 1-specen) — ingen roterande/animerad
kant i skarp config, det var bara mockup-smek i Riggsmedjan/Bokstavssmedjan.

**Animationer:**
- Fönster öppna/stäng: **popin** (växer från mindre storlek, t.ex. 80% → 100%)
- Workspace-byte: **slide**
- Tempo: **snabbt/snappy** — korta durationer (~150-200ms), rät/snäv easing,
  inte den gamla `easeOutCubic ~300ms`-känslan från placeholder-configen.
- **Justerat 2026-09-15:** nytt-fönster-animationen (`windows`/`windowsOut`)
  gjord **långsammare och lite bouncy** igen — egen `bouncy`-kurva (easeOutBack-
  stil overshoot, `speed 3→5`). Fullscreen-övergången (`windowsMove`) gjord
  **långsammare** med en mjuk, icke-studsig `smooth`-kurva (`speed 6`).
  Workspace-slide/border/fade rörda inte, fortfarande snappy.

```
-- hyprland.lua (riktning, exakta bezier-värden återstår vid implementation)
hl.animation({ leaf = "windows", enabled = true, speed = 2, style = "popin 80%", bezier = "snappy" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, style = "slide", bezier = "snappy" })
hl.curve("snappy", { type = "bezier", points = { { 0.2, 0.9 }, { 0.3, 1 } } })  -- kort, rät kurva, ej overshoot
```

**Rofi:** `grid`-läge, storlek nära fullskärm (~85-90% av skärmen) — "massor med appar
synliga samtidigt", centrerad. Live-filtrering medan man skriver är rofis
standardbeteende oavsett läge (icke-träffar försvinner automatiskt) — kräver ingen
extra konfiguration. **Ikonberoende:** grid ser bara bra ut om apparna faktiskt har
riktiga ikoner installerade (GTK icon theme) — kolla det vid implementation, annars
blir det tomma rutor med text under.

**Notiser (swaync):** position topp-höger. Standardvy **kompakt** (ikon + titel + en
rad), som ska **expandera vid hover** och visa fullständig detaljerad info.
⚠️ **Att verifiera vid implementation:** hover-to-expand är inte ett dokumenterat
standardläge i swaync — kan kräva CSS/JS-hack i `swaync/style.css`/`config.json`,
eller så får click-to-expand bli den realistiska kompromissen om hover visar sig
opraktiskt (t.ex. notisen försvinner/timeout medan musen är på väg dit).

**Cursor:** **Adwaita** (GNOME-standard), **24px**. Medvetet valt bort Bibata/färgat
tema — noll extra installation, redan tillgängligt som fallback på de flesta system.

**hyprlock:** **minimal** — stor klocka centrerat, lösenordsfält under, blurrad
wallpaper som bakgrund. Ingen avatar, inget extra info-lager, inte en waybar-kopia.
**Uppdaterat 2026-09-15:** bakgrunden är nu den riktiga skogsbilden
(`images/backgrounds/forrest-background1.png`) istället för `path = screenshot`
(som blurrade den levande skärmen). Inte testat live av mig — kräver att låsa
skärmen, vilket jag inte gör utan lösenordsåtkomst att låsa upp med igen. Jakob
verifierar själv med `Super+L`.

**wlogout:** **ikon-rad utan textetiketter** (som i Riggsmedjan-mockupen) — lås/logga
ut/starta om/stäng av som rena cirkulära ikonknappar.

**btop:** befintligt **Gruvbox community-tema** rakt av (inte en egen `.theme`-fil
med exakta hex-värden — medvetet val, "i praktiken samma palett" räcker).
Panelval/layout blev en egen sak, se nedan.

**fastfetch:** **klassisk** — distro-logga (EndeavourOS ASCII/ANSI) till vänster,
kärnspecs till höger (OS, kernel, uptime, paket, shell, DE, CPU/GPU, minne).

**starship:** **medel** — katalog + git-status. Inga språkversions-badges
(Python/Node osv), inget exit-code-märke.

### Eww-systemmeny — byggd 2026-09-15

Svaret på "vilken btop-layout" blev egentligen en helt annan sak: en **GNOME quick-
settings-stil eww-meny**. Designad i Artifacten [[../05-todo/menysmedjan]] och sedan
byggd på riktigt, se [[../05-todo/wishlist]] för slutgiltigt scope (fristående 4:e
meny, minne/temp/nät + wifi/stör-ej/ljud/inställningar/lås-skärm — **CPU/GPU
uteslutna**, Jakob ville ha dem kvar direkt synliga i waybar). Wifi/Stör ej är
riktiga toggle-switchar (eww `checkbox` omstylad till pillerform, ingen `switch`-
widget finns i eww). Ny "Inställningar"-knapp öppnar `gnome-control-center`.

Samtidigt: waybar fick en diagonal gradient + guld-underglöd (mindre platt),
`margin-left`/`margin-right` 10→0 (ingen gap mot skärmkant), och Hyprlands
`gaps_in`/`gaps_out` 8/14 → 4/6 (mindre mellanrum mellan fönster).

**Uppdaterat igen samma dag:** wifi fanns dubbelt (egen `network`-modul i
waybar som öppnade `wifi-menu`, OCH en till toggle inne i den nya
systemmenyn). Städat: `network`-modulen borttagen helt ur waybar, systemmenyns
"Nätverk"-rad är nu klickbar och öppnar den fullständiga `wifi-menu` (med
nätverkslista) istället för att duplicera en enkel på/av-toggle. `custom/cava`
flyttad till `modules-center` (mellan mpris och klockan, "vänster om tid") och
gjord bredare (`bars` 8→18 i `cava/waybar.conf`).

**custom/power-profile borttagen:** fanns två vägar att ändra power-profile
(batteriets högerklick + en egen modul) — battery-menu hade redan en
fullständig väljare, så modulen och dess två skript togs bort helt.

**Systemmeny-ikonen** (📊-emoji) byttes mot en riktig Nerd Font-glyf
(tachometer, U+F0E4) — konsekvent med barens övriga monokroma ikoner.
Verifierade glyfen fanns i fonten först (`fc-list ":charset=F0E4"`).

**GNOME quick-settings-layout (samma dag, senare):** Jakob ville låna själva
layouten från GNOMEs quick-settings-panel — inte panelen bokstavligen (den
sitter hårdkodad i gnome-shell, går inte att återanvända i Hyprland), utan
**mönstret**: fyrkantiga toggle-brickor sida vid sida istället för radlista.
Byggt i vår egen palett, inte GNOME:s blå/grå (bekräftat med Jakob). Wifi och
Stör ej är nu `.tile`-brickor i `eww.scss` — aktiv fylls solid guld med mörk
text/ikon, inaktiv är dämpad.

Upptäckt på vägen: **jag kan inte skriva Nerd Font PUA-glyfer (U+E000–U+F8FF)
direkt i mina svar** — tecknet blev en tyst tom sträng i filen, syntes bara
osynligt eftersom min egen terminalvy saknar typsnittet. Lösning: injicera
exakt codepoint via `python3` (`'\U0000XXXX'`-escape, 8 hex-siffror) istället
för att skriva glyfen själv, verifierat med en hexdump efteråt. La till Vila/
Starta om/Stäng av (samma `systemctl`-kommandon som wlogout) i systemmenyn,
med röd varningsfärg på de två sistnämnda. swaync fick två till fixar samma
dag: blur-ytan sträckte sig ner till skärmens botten trots litet notiskort
(Hyprlands `layerrule = blur` täcker hela layer-ytan, inte bara synligt
innehåll — `ignorezero` stöds inte av vår lua-bindning, så blur stängdes av
helt för notis-fönstret istället), och notis-bakgrunden fick högre alpha
(0.68→0.92) eftersom den utan blur kändes för genomskinlig/svårläst.

### Estetisk preferens noterad 2026-09-15: mörkt/mulet/sinister vinner

När `vårskog`-bilderna (se [[../02-beslut/changelog]], översvämmad skog i
april, mulet/regnigt) började loopa som wallpaper sa Jakob (trodde det var
höst, var faktiskt vår): "gillar det för det är lite mörkare och mer
sinister, med regn och träsk". Bekräftar riktningen för hela riggen (mörkgrön/
dämpad, inte ljus/snöig) — de **stående vinterbilderna** (ljus snö, som första
sorteringsförsöket lyfte fram estetiskt innan det byttes till ett tekniskt
kriterium) är alltså **inte** rätt känsla ändå, oavsett komposition. Om fler
wallpaper-bilder läggs till framöver: prioritera mulet/regnigt/träsk-aktigt
över ljust/snöigt/soligt.

### Kvar att bestämma (fylls i allt eftersom)
- [x] ~~btop/fastfetch/starship~~ (se ovan) — cava redan klar sedan runda 3 (waybar-
      visualisering, ingen ändring)
- [x] ~~Cursor~~ (se ovan)
- [x] ~~hyprlock~~ (se ovan)
- [x] ~~wlogout~~ (se ovan)
- [x] ~~Rofi-layout~~ (se ovan)
- [x] ~~Notiser~~ (se ovan)
- [x] ~~Animationer~~ (se ovan)
- [x] ~~Gradient-kant~~ (se ovan) — avfärdad, bara solid kant
- [x] ~~Waybar-layout~~ (se ovan)
- [x] ~~Wallpaper~~ — **Jakobs eget beslut, inte del av frågerundorna.** Bekräftat:
      verktyg blir **hyprpaper** (byte från `swaybg`, som är vad som faktiskt kör just
      nu, se [[../01-appar/hyprland]]/`ps aux`). Vilken bild och hur den konfigureras
      bestämmer Jakob själv och meddelar när det är klart.
## Implementation klar (2026-09-14)

Alla beslut ovan är nu genomförda i de faktiska config-filerna, inte bara
dokumenterade. Filer som ändrades:

- `hypr/hyprland.lua` — gaps/rounding/border/blur/opacity (Glassy), kantfärger
  (forest-palett), snappy-animationskurva (`hl.curve("snappy", ...)`), lägre
  animation-speed-värden.
- `hypr/hyprpaper.conf` — **ny fil**, wallpaper.
- `hypr/autostart.lua` — `swaybg` → `hyprpaper`, la till `hyprctl setcursor Adwaita 24`.
- `hypr/hyprlock.conf` — recolor + blur size/passes uppjusterat till samma som resten.
- `hypr/rules.lua` — rofi-opacity 0.88 → 0.82.
- `kitty/kitty.conf` — IBM Plex Mono, `symbol_map` mot JetBrainsMono Nerd Font för
  ikonglyfer (Plex saknar dem), full ANSI-ompalettering, `background_opacity 0.85`.
- `waybar/config.jsonc` — `mpris`-modul tillagd, `hyprland/workspaces` till
  punkt-format + `persistent-workspaces`, tog bort `custom/sep1-3` (onödiga med
  kapsel-gruppering).
- `waybar/style.css` — full recolor, `.modules-left/-center/-right`-kapslar,
  punkt-workspace-stil, font-stack med Nerd Font-fallback.
- `rofi/colors.rasi` — full recolor, döpte om variabler (`orange`→`gold`,
  `cyan`→`leaf`, matchar faktiska hexvärden nu).
- `rofi/config.rasi` — grid-läge (7 kolumner, ikon-över-text), centrerad, 82%×82%
  av skärmen, `@orange`→`@gold`-referensen fixad.
- `swaync/style.css` — full recolor, samt en CSS-baserad hover-expand-approximation
  (⚠️ inte swaync-standard, se kommentar i filen och flagga nedan).
- `wlogout/style.css` — full recolor, ikon-rad utan text via
  `-gtk-icontheme()` (Adwaita symbolic-ikoner; suspend saknar egen ikon i Adwaita,
  återanvänder månikonen `weather-clear-night-symbolic`).
- `btop/btop.conf` — `color_theme = "forest"`, `shown_boxes = "cpu mem"` (minimal).
- `btop/themes/forest.theme` — **ny fil**, egen tema-fil (inte ett nedladdat
  community-tema — se överspelnings-noten ovan).
- `fastfetch/config.jsonc` — logga/keys recolor (hex direkt, inte ANSI-namn).
- `starship.toml` — recolor, struktur oförändrad (katalog + git-status, "medel").

**Validerat innan commit:** `Hyprland --verify-config` → `config ok`, `luac5.4 -p`
på alla `.lua`-filer, JSON/JSONC-parsning av `waybar/config.jsonc`,
`fastfetch/config.jsonc`, `swaync/config.json`. Inget av detta är laddat i den
körande sessionen än — kräver reload/omstart, som inte görs utan att fråga.

### ⚠️ Kvarstår / att verifiera

- ~~`ttf-ibm-plex` inte installerat~~ — **löst.** Jakob körde `sudo pacman -S
  ttf-ibm-plex` själv. Verifierat visuellt: öppnade en riktig kitty-ruta (`grim`
  + skärmdump), starship-prompten renderar korrekt med guld/grön-paletten,
  rundade hörn (18px) syns på fönstret.
- ~~swaync hover-to-expand~~ — **avfärdad 2026-09-15.** Jakob gillade inte att
  kontrollcentret tog upp typ halva skärmen och ville hellre ha det enkelt.
  Orsaken var `fit-to-screen: true` i `config.json` (gjorde att kontrollcentret
  sträckte sig oavsett `control-center-height`) — satt till `false`, och
  `control-center-width/height`/`notification-window-width` neddragna
  (400/600/400 → 340/420/340). Hover-expand-CSS:n borttagen helt (GTK-CSS har
  ingen riktig line-clamp-egenskap att ersätta den med ändå). Click-to-expand
  bedömdes inte vara "lätt" (kräver swaync-scripting, inte ren CSS) — hoppat
  över per Jakobs egen "om lätt"-brasklapp. Verifierat med riktiga
  notis-/kontrollcenter-skärmdumpar: kompakt, som avsett.
- **Rofi grid** ser bara bra ut om `Qogir-Dark`-ikontemat faktiskt har bra
  ikontäckning för installerade appar — inte dubbelkollat.
- **eww-systemmenyn** (GNOME quick-settings-stil) är fortfarande ett separat,
  obörjat projekt — se [[../05-todo/wishlist]].

### Efterjusteringar (samma dag, efter första implementationen)

**Borders bytta guld → mörkgrön** (`#3f5c42`). Gäller specifikt kant-egenskaper,
inte fyllningar/text/ikoner (de är fortfarande guld där de var det): Hyprlands
`col.active_border`, kittys `active_border_color`, rofis `border-strong`/
`selected-border`, swaycs `@border`, wlogouts button-border, waybar-tooltipens
kant, hyprlocks `outer_color`.

**Tre filer som missades i den stora implementationsomgången, hittade via en
bredare grep-sökning efteråt och nu fixade:**
- `wob/wob.ini` — hade fortfarande hela den gamla cyan/mörkblå paletten
  (`border_color`, `background_color`, `bar_color`). Nu forest-palett + grön kant.
- `cava/config` (den fristående, inte `waybar.conf`) — gradient var fortfarande
  gammal cyan/lila. Nu guld→löv-grön.
- `eww/eww.scss` — **hela** wifi-/volym-/batteri-menyerna var fortfarande på den
  gamla paletten (missades helt i första omgången). Full recolor + `IBM Plex
  Mono`-fontstack. Upptäckte samtidigt att dessa eww-fönster (namespace
  `eww-dropdown`) aldrig hade en blur-`layer_rule` — tillagd i `rules.lua` så
  Glassy-bluren faktiskt gäller dem också.
- Två kvarglömda `#07090f`-textfärger i `swaync/style.css` (hover-text på
  knappar) → `#17211a`.

**Workspace-indikatorn förstärkt** (Jakob tyckte punkterna var för otydliga —
bekräftat med en zoomad skärmdump, de fanns men var för subtila): inaktiva
punkter lövgröna istället för gråa (mer färgkontrast mot mörkgrön bakgrund),
storlek 10px→15px, aktiv 13px→23px (mycket tydligare skillnad), aktiv workspace
får nu även en egen rund guld-tonad badge-bakgrund istället för bara textfärg.

## Tidigare placeholder-tema (ersätts, kvar som historik)

Genomgående mörk, "neon på natthimmel"-palett med JetBrainsMono Nerd Font.

### Färger (bekräftade i kitty + starship + hyprlock)

| Roll | Hex | Används i |
|---|---|---|
| Bakgrund | `#070910` | kitty, starship-segment |
| Text/förgrund | `#e8f1ff` | kitty, hyprlock-klocka |
| Accent 1 (cyan) | `#62e6ff` | starship directory-segment, hyprlock-klocka (rgba 232,241,255) |
| Accent 2 (lila) | `#a970ff` | starship git-segment |

`rofi/colors.rasi` hade troligen samma palett — aldrig färdig-extraherad.

### Font

JetBrainsMono Nerd Font genomgående (kitty, hyprlock).

### Formspråk (Hyprland)

- `rounding = 8`, `border_size = 2`
- `active_opacity = 1.0` / `inactive_opacity = 0.94`
- Blur: 2 passes, storlek 6, `ignore_opacity = true`
- Animationer: `easeOutCubic`/`easeInOutCubic`, popin 80% för fönster, slide för workspaces

### Wallpaper

`~/Bilder/Wallpapers/hyprland-nebula.png` — matchade den gamla palettens "nebulosa"-känsla.
