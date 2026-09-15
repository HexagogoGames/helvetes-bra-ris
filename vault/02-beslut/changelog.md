# Changelog

Nyast överst.

## 2026-09-15 — Spotify + eget Spicetify-tema (Svensk skog) live

Jakob installerade `spotify-launcher` (officiella `extra`-repot) och
`spicetify-cli` (AUR via yay) själv. Claude laddade ner Spotify-klienten
(`spotify-launcher --no-exec` för att inte öppna ett onödigt GUI-fönster),
startade den sedan på riktigt för att skapa prefs-filen, och byggde ett eget
tema i `~/.config/spicetify/Themes/SvenskSkog/` mot den riktiga
referensmallen i `/opt/spicetify-cli/Themes/SpicetifyDefault/` (inte gissat
color.ini-format) — `color.ini` mot exakt
[[../04-tema/svensk-skog-palett]]-paletten, `user.css` baserad på spicetifys
egna sensible defaults. Jakob loggade in själv, `spicetify backup apply`
kört, bekräftat live med skärmdump (mörkgrön bakgrund, guld progressbar,
musik spelar). Flyttade sedan in temat i dotfiles-repot
(`spicetify/Themes/SvenskSkog/`, symlinkad till `~/.config/spicetify/Themes/
SvenskSkog`) på Jakobs begäran — bara själva temat, inte `CustomApps`/
`Extensions`/`config-xpui.ini`. Tillagd i CLAUDE.md:s mappningstabell.

## 2026-09-15 — Paletten officiellt döpt "Svensk skog", Spotify-plan i wishlist

Jakob döpte färgschemat till **"Svensk skog"** och ville ha det formaliserat
i vault. Skapade [[../04-tema/svensk-skog-palett]] som den nya kanoniska
referensen (hex-tabell inkl. border-färgen som saknades i den gamla tabellen,
border-regeln, var den används) — `design.md` länkar dit istället för att
duplicera. Städade två föråldrade referenser till "Gruvbox Dark" i
`wishlist.md` som blivit fel sedan färgbytet till Svensk skog.

Jakob vill installera Spotify + Spicetify (kräver `sudo`/AUR, körs av honom
själv) och få ett eget spicetify-tema i exakt Svensk skog-paletten senare —
lagt i [[../05-todo/wishlist]].

## 2026-09-15 — Full resursgenomgång: wob var död, ac-sound-watch sårbar

Jakob bad om en fullständig genomgång efter cava-läckan. Hittade två till
strömmande skript med samma sårbarhetsmönster: `wob-init.sh` (samma
`tail -f | wob`-pipe som cava hade — och visade sig vara **helt död**, ingen
läste längre från pipen, så volym-/ljusstyrke-OSD:n visade ingenting) och
`ac-sound-watch.sh` (oändlig `while true` för laddar-ljud, bara en instans
men samma latenta risk). Båda fick samma self-cleanup-tillägg som
`cava-waybar.sh`. Startade om `wob` och verifierade OSD-stapeln fungerar
igen med en skärmdump.

Bredare koll utöver det: inga dubbla waybar/eww/swaync/hyprpaper-instanser,
inga zombie-processer, minnet dominerat av Firefox/VS Code/Claude (inte
riggen). Inget annat läcker just nu. Se
[[../03-felsokning/cava-process-lacka]] för allt i detalj.

## 2026-09-15 — Hittade och fixade en riktig resursläcka: 22 cava-processer

Jakob undrade om 12% GPU var mycket för idle desktop och bad om en generell
resurs-felsökning ("om något i min rice tar för mycket vill jag att det ska
ändras på"). Hittade **22 st körande `cava`-processer**, varav bara 2 hörde
till den faktiska waybar-instansen — resten föräldralösa efter upprepade
waybar-omstarter under kvällen. Orsak: `cava-waybar.sh` körs som en
strömmande modul som aldrig dör med waybar (blir barn till `init` istället)
— **händer vid varje waybar-omstart**, inklusive Jakobs egen
`Super+Shift+R`-genväg, inte bara under den här sessionen.

Fixat: skriptet dödar nu sina egna gamla instanser innan det startar en ny.
Testat med 3 omstarter i rad — exakt en ren instans kvar varje gång. Se
[[../03-felsokning/cava-process-lacka]] för detaljer.

## 2026-09-15 — GNOME quick-settings-layout i systemmenyn (egen palett)

Jakob ville låna layouten från GNOMEs quick-settings-panel för Wifi/Stör ej —
inte panelen bokstavligen (sitter hårdkodad i gnome-shell), utan mönstret:
fyrkantiga toggle-brickor sida vid sida istället för radlista, aktiv fylls
solid (i vår guld-palett, bekräftat med Jakob — inte GNOME:s blå/grå).
Implementerat som `.tile-grid`/`.tile` i `eww.scss`.

Hittade en genuin begränsning på vägen: **Nerd Font PUA-glyfer (U+E000–
U+F8FF) går inte att skriva direkt i mina svar** — blir tysta tomma strängar
i filen. Löst genom att injicera exakt codepoint via en liten `python3`-
engångskörning (`'\U0000XXXX'`-escape) istället, verifierat med hexdump att
rätt UTF-8-bytes faktiskt landade. Se [[../04-tema/design]] för detaljer.

## 2026-09-15 — Hittade den riktiga swaync-bulan (blur, inte storlek), bytte ikon

Jakob rapporterade att swaync-notiser fortfarande "sträckte sig över för stor
del av skärmen" trots gårdagens storleksfix. Testade live — notiskortet
självt var faktiskt redan litet (~340px), men den **suddiga (blurrade) ytan**
sträckte sig ända ner till skärmens botten. Orsak: Hyprlands
`layerrule = blur` täcker hela layer-surface-rektangeln, och swaync gör den
ytan hög (för att kunna stapla flera notiser), inte bara det synliga kortet.
Provade `ignorezero` (blurra bara där alpha > 0) men den lua-bindningen stödjer
inte det fältet ("unknown field") — enklaste fixen blev att stänga av blur
helt för `swaync-notification-window` (kontrollcentret behåller sin, det är en
fast liten yta utan samma problem). Verifierat med `--verify-config` och en
riktig testnotis.

Samtidigt: systemmeny-ikonen i waybar (📊-emoji) byttes mot en riktig Nerd
Font-glyf (tachometer/mätare, U+F0E4) — konsekvent med resten av barens
monokroma ikoner istället för en färgad emoji. Verifierade att glyfen faktiskt
finns i fonten först (`fc-list ":charset=F0E4"`) innan jag gissade.

## 2026-09-15 — Slog ihop dubbla power-profile-kontroller till en

Jakob påpekade att power-profile kunde ändras på två ställen: batteriets
högerklick (hårdkodad till power-saver) och en separat `custom/power-profile`-
modul (cyklar alla tre lägen). Battery-menyn (öppnas via vänsterklick på
batteriet) har redan en fullständig profilväljare med tidsuppskattningar per
läge — så den täcker samma behov bättre. Tog bort `custom/power-profile`-
modulen och dess två skript helt, samt batteriets `on-click-right`-genväg.
Kvar: **en** väg att ändra power-profile — klicka batteriet, välj i menyn.
Städade bort matchande död CSS (inklusive en kvarglömd `#network`-referens
sedan wifi-konsolideringen).

## 2026-09-15 — Power-knappar i systemmenyn (vila/starta om/stäng av)

La till Vila, Starta om, Stäng av i eww-systemmenyn (samma `systemctl`-kommandon
som wlogout redan använder) — Jakob ville ha dem åtkomliga där också, inte bara
via wlogout-overlayn. Starta om/Stäng av fick en röd varningsfärg (`.menu-item
danger`) för att skilja dem visuellt från de mindre drastiska knapparna, ingen
extra bekräftelsedialog (matchar wlogouts eget beteende — direkt vid klick).
Verifierat med skärmdump (klickade inte på dem, av uppenbara skäl).

## 2026-09-15 — Städade bort dubbel wifi, cava bredare och flyttad

Jakob påpekade att wifi fanns på två ställen: en egen `network`-ikon i waybar
(öppnade `wifi-menu`) och en toggle inne i den nya systemmenyn. Tog bort
`network`-modulen ur waybar helt — systemmenyns "Nätverk"-rad är nu klickbar
och öppnar `wifi-menu` (med den riktiga nätverkslistan) istället för att
duplicera logiken. Samtidigt: `custom/cava` flyttad till `modules-center`
(mellan mpris och klockan) och gjord bredare (`bars` 8→18). Städade också bort
kvarglömda `custom/sep1-3`-definitioner (redan overksamma sedan
kapsel-grupperingen). Verifierat live med skärmdump.

## 2026-09-15 — Eww-systemmenyn byggd och live, waybar-städning + dekor

Byggde den tidigare designade eww-systemmenyn på riktigt (inte bara Artifact-
mockup): ny `system-menu` i `eww.yuck` visar Minne/Temperatur/Nätverk +
snabbåtgärder (Wifi, Stör ej, Ljudinställningar, Lås skärm), öppnas via en ny
📊-modul (`custom/systemstats`) i waybar. Datakälla: nytt skript
`eww/scripts/system-stats.sh`, delat med waybars tooltip via
`waybar/scripts/systemstats-tooltip.sh`.

Jakob ville ha **CPU% och GPU% kvar synliga direkt i waybar** (inte gömda i
menyn) — så bara minne/temp/nätverk flyttades in, `cpu`/`custom/gpu`-modulerna
återställda med samma beteende som förut (klick öppnar btop/intel_gpu_top).

Två fällor på vägen, dokumenterade i
[[../03-felsokning/eww-locale-och-scss-quirks]]: systemet kör svensk locale så
`top`/`free` byter fältnamn och decimaltecken (måste tvinga `LC_ALL=C`), och en
svensk bokstav + emoji i en `eww.scss`-kommentar fick ewws SCSS-kompilator att
injicera en `@charset`-rad som eww sen inte kunde tolka.

Övrigt samtidigt:
- Waybar: mer dekorativ (diagonal gradient istället för platt yta, varm
  guld-underglöd), `margin-left`/`margin-right` 10→0 (ingen gap mot skärmkanten).
- Hyprland: `gaps_in`/`gaps_out` 8/14 → 4/6 (mindre mellanrum mellan fönster).
- Tog bort `waybar/scripts/gpu.sh` och la sen tillbaka den (kort felaktig
  borttagning under omstruktureringen).

Uppdaterad [[../05-todo/wishlist]] — eww-systemmenyn är nu avbockad.

## 2026-09-15 — Eww-systemmenyns designrunda påbörjad, animationer justerade

Byggde en fjärde provrums-Artifact, "Menysmedjan"
([[../05-todo/menysmedjan]]), för spinoff-projektet eww-systemmeny: struktur
(fristående vs. ihopslagen med wifi/volym/batteri), utlösarplats i waybar,
vilka snabbåtgärder/info som ska ingå, och om en utökad vy med sparklines ska
finnas. Låst mot det riktiga färdiga temat (mörkgrönt/guld) för korrekt förhandsvy.
Väntar på Jakobs val innan implementation.

Samtidigt: nytt-fönster-animationen gjord långsammare och lite bouncy (egen
`bouncy`-kurva, easeOutBack-stil), och fullscreen-övergången (`windowsMove`)
gjord långsammare med en mjuk `smooth`-kurva. Se [[../04-tema/design]].

## 2026-09-15 — swaync förenklad: bort med hover-expand, mindre storlek

Jakob gillade inte att swaycs kontrollcenter tog upp typ halva skärmen. Orsaken:
`fit-to-screen: true` gjorde att det sträckte sig oavsett satt höjd. Satt till
`false`, dragit ner `control-center-width/height` och
`notification-window-width` (400/600/400 → 340/420/340). Tog bort hela
hover-to-expand-CSS-hacket (avfärdat — GTK-CSS saknar en riktig
line-clamp-egenskap, och click-to-expand bedömdes inte vara "lätt" nog för att
vara värt det). Verifierat med riktiga skärmdumpar av både en testnotis och
kontrollcentret — kompakt nu.

## 2026-09-15 — Reload genomförd: hyprpaper-schemat var fel, waybar mer transparent

Körde `hyprctl reload` + omstart av waybar/wob/eww/swaync/wallpaper-daemon (godkänt
av Jakob). Upptäckte att `hyprpaper.conf` inte fungerade alls — den installerade
hyprpaper-versionen (byggd mot hyprtoolkit) använder ett helt nytt config-schema
(`wallpaper { monitor = ...; path = ...; fit_mode = cover }` istället för klassiska
`preload=`/`wallpaper=`-rader). Se [[../03-felsokning/hyprpaper-nytt-config-schema]]
för hur det spårades ner. Wallpapern syns nu bekräftat (skärmdump).

Hittade och fixade tre filer som missats helt i förra implementationsomgången:
`wob/wob.ini`, `cava/config`, `eww/eww.scss` (alla hade fortfarande hela den gamla
cyan/blå paletten). La till en blur-`layer_rule` för eww-dropdown-fönstren som
aldrig haft en.

Jakob bad om mörkgröna borders istället för guld (gäller bara kant-egenskaper,
inte fyllningar) — uppdaterat i Hyprland/kitty/rofi/swaync/wlogout/hyprlock/waybar.
Förstärkte waybars workspace-dots (lövgröna istället för grå, större
storleksskillnad aktiv/inaktiv, egen badge-bakgrund) efter att en zoomad
skärmdump visade att de fanns men var för subtila.

Verifierade `ttf-ibm-plex` installerat (Jakob körde själv) med en riktig
kitty-skärmdump — starship/font/rundade hörn renderar korrekt.

Sist: gjorde waybar mer transparent (0.6→0.38 alpha) och gav klickbara moduler
en tydlig "knapp"-look (egen chip med kant, hover-lyft) istället för bara text på
rad. Justerade `height` i config.jsonc 34→44 för att matcha den nya modulhöjden.

**eww-systemmenyn (GNOME quick-settings-stil)** sparas medvetet till en egen
designrunda efter att temat är klart — se [[../05-todo/wishlist]].

## 2026-09-14 — Temaomdesign implementerad: Glassy + egen "forest"-palett

Jakob bytte estetik Vibrant → Glassy, la in sin egen wallpaper
(`forrest background1.avif`, konverterad till PNG) och bad om en mörkgrön/
genomskinlig palett hämtad ur bilden istället för Gruvbox Dark. Extraherade
riktiga dominant-färger ur fotot med ImageMagick och byggde paletten på dem
(botten `#17211a`, guld-accent `#d4a24a`, löv-grön `#7fa66b`, se
[[../04-tema/design]] för fullständig tabell).

**Implementerade allt i skarpa config-filer** (inte bara beslutat): hyprland.lua
(gaps/rounding/blur/opacity/animationer/kantfärger), hyprpaper.conf (ny),
autostart.lua (swaybg→hyprpaper, cursor-setup), hyprlock.conf, kitty.conf (IBM
Plex Mono + symbol_map-fallback för ikoner), waybar config.jsonc+style.css
(mpris, punkt-workspaces, kapslar), rofi (grid-läge, recolor), swaync (recolor +
hover-expand-försök), wlogout (recolor + `-gtk-icontheme()`-ikoner), btop (eget
"forest"-tema, minimal layout), fastfetch, starship.toml.

Validerat: `Hyprland --verify-config` → `config ok`, Lua-syntax, JSON/JSONC.
**Inget laddat i den körande sessionen än** — väntar på godkännande för
reload/omstart. Kvarstår: `ttf-ibm-plex` måste installeras manuellt (kräver
sudo), swaync-hovern är en CSS-approximation att verifiera i praktiken.

## 2026-09-14 — Estetik ändrad Vibrant → Glassy, påbörjar implementation

Jakob bytte sista minuten-beslut: **Glassy** istället för Vibrant (rounding 18,
border_size 1, blur på/size 8/passes 3, active/inactive opacity 0.92/0.62, gaps
8/14). Allt annat i [[../04-tema/design]] oförändrat. Alla beslut är nu klara —
påbörjar faktisk implementation i config-filerna.

## 2026-09-14 — Temaomdesign klar: btop/fastfetch/starship + nytt spinoff-projekt

Sista rundan: **btop** befintligt Gruvbox-community-tema (inte eget hex-exakt tema),
**fastfetch** klassisk (logga + specs), **starship** medel (katalog + git-status).
Jakobs svar om btop-layout visade sig egentligen beskriva en helt annan sak — en
**GNOME quick-settings-stil eww-systemmeny** (kompakt + utökad vy, info + snabb-
åtgärder som wifi-toggle, inte btop-baserad). Flyttat till [[../05-todo/wishlist]]
som ett eget framtida projekt istället för att klämmas in här.

**Alla frågerundor för temaomdesignen är nu klara** — se [[../04-tema/design]] för
den fullständiga sammanställningen. Nästa steg är att faktiskt implementera
besluten i config-filerna (inte gjort än, bara beslutat).

## 2026-09-14 — Cursor, hyprlock, wlogout beslutade

Runda 6: **cursor** Adwaita 24px (medvetet inget custom-tema, noll extra
installation). **hyprlock** minimal — klocka + lösenordsfält, blurrad wallpaper,
inget mer. **wlogout** ikon-rad utan textetiketter. Enda kvarvarande punkten:
matcha btop/fastfetch/cava/starship mot Gruvbox-paletten. Detaljer i
[[../04-tema/design]].

## 2026-09-14 — Rofi + notiser beslutade

Runda 5: **rofi** blir `grid`-läge nära fullskärm, centrerad — live-filtrering medan
man skriver är rofis standardbeteende, ingen extra konfig krävs. **Notiser**
(swaync) topp-höger, kompakt som standard men ska expandera vid hover för
detaljerad vy — flaggat i [[../04-tema/design]] som osäkert (inte standard-swaync,
verifieras vid implementation). Ikonberoende för rofi grid också flaggat.

## 2026-09-14 — Animationer beslutade, gradient-kant avfärdad

Runda 4: fönster **popin** vid öppning/stängning, **slide** vid workspace-byte,
tempo **snabbt/snappy** (~150-200ms). Den roterande gradient-kanten från mockuparna
blir **inte** en skarp Hyprland-effekt — bara enkel solid accentkant
(`col.active_border = fe8019`, redan beslutad i runda 1). Detaljer i
[[../04-tema/design]].

## 2026-09-14 — Waybar-layout beslutad: topp, kapslar, punkter, + mpris

Runda 3 (Panelsmedjan) klar: panel i **toppen**, moduler grupperade i **kapslar**
(rundad bakgrund per zon), workspace-stil **punkter** (inga siffror). Ny modul:
**mpris** (media-widget) tillagd i center-zonen. Övriga moduler (cava, gpu, network,
battery, power-profile) oförändrade. `custom/tray`/väder inte tillagda. Färdig
`config.jsonc`/`style.css`-skiss i [[../04-tema/design]].

## 2026-09-14 — Typografi beslutad: IBM Plex Mono, medel, glyf-ikoner

Runda 2 (Bokstavssmedjan) klar: **IBM Plex Mono överallt** (UI + terminal), textstorlek
**medel** (waybar 13px, kitty 12.0pt), **inga ligaturer** (fonten saknar dem), **glyf-
ikoner** i waybar (befintlig konvention). Detaljer och färdiga config-snuttar i
[[../04-tema/design]].

## 2026-09-14 — Wallpaper: Jakobs eget beslut, verktyg blir hyprpaper

Jakob bestämmer wallpaper-bild och -konfiguration helt själv, inte via
frågerundorna. Bekräftat verktygsval: **hyprpaper** ersätter `swaybg` (som är vad
som faktiskt kör i autostart just nu). `hyprpaper 0.8.4-8` redan installerat.
Rör inte `autostart.lua` förrän Jakob är klar och ber om bytet. Byggde en andra
Artifact, "Bokstavssmedjan" ([[../05-todo/bokstavssmedjan]]), för runda 2:
typografi (fontparning/ligaturer/storlek/ikonstil) ovanpå det låsta
Vibrant/Gruvbox Dark-läget.

## 2026-09-14 — Temaomdesign påbörjad: Vibrant + Gruvbox Dark

Jakob beslutade att göra om hela tema/layout-designen från grunden — allt tidigare
var placeholder. Byggde en interaktiv Artifact ("Riggsmedjan",
[[../05-todo/temaverkstad]]) för att utforska estetik × färgschema × mättnad live.
Första beslutet: **estetik Vibrant, mörkt läge, Gruvbox Dark-palett** (accent
`#fe8019`, rounding 14, border_size 3, gaps 8/12, lätt blur, active/inactive
opacity 0.97/0.78). Detaljer i [[../04-tema/design]]. Fortsätter runda för runda
(typografi, waybar-layout, wallpaper, animationer, rofi/notiser, osv.).

## 2026-09-14 — Lade till `.gitignore`

Fanns ingen tidigare. Lade till `*.code-workspace` (fångar VS Codes tendens att
återskapa en tom `rice.code-workspace`, se raden nedan) samt vanligt editor-/OS-skräp
(`.vscode/`, swap-filer, `.DS_Store`).

## 2026-09-14 — Waybar-knappen öppnar dotfiles direkt, workspace-fil borttagen

`custom/hyprland-config`-modulen i waybar döpt om till `custom/dotfiles` och
`on-click` ändrad från `code --new-window ~/dotfiles/rice.code-workspace` till
`code --new-window ~/dotfiles` — öppnar repot direkt istället för via en separat
multi-root-workspace-fil. `rice.code-workspace` borttagen (innehöll bl.a. en
föråldrad referens till den redan borttagna `hypr.conf-backup-20260913/`, och hette
mappen `vault (anteckningar)` internt — därav döptes vault-rubrikerna om tidigare
idag). Uppdaterade CSS-selektorer i `waybar/style.css` och noterna i
[[../01-appar/waybar]] och [[../00-oversikt/dotfiles-struktur]] i samma veva.

Waybar körde fortfarande gamla configen i minnet efter redigeringen (startades vid
omstarten, innan filen ändrades) — knappen pekade tillfälligt på den redan borttagna
`rice.code-workspace` och gjorde inget vid klick. Jakob startade om waybar manuellt;
knappen bekräftat fungerande efteråt.

## 2026-09-14 — Hyprland lua-migrering klar, backup borttagen

Jakob startade om datorn. `hyprctl systeminfo` bekräftar `configProvider: lua`,
`hyprctl configerrors` tomt, och autostart (waybar/swaync/eww/swaybg/cava) kom upp
korrekt. Lua-configen är alltså verifierad i praktiken, inte bara syntaktiskt. Tog
bort `hypr.conf-backup-20260913/` (repo + symlink i `~/.config/`) — behövs inte
längre. Se [[../03-felsokning/hyprland-lua-migration]].

Samtidigt: gjorde vault-hanteringen i `CLAUDE.md` till en tydlig, obligatorisk rutin
(sköts automatiskt, utan att fråga om lov) istället för en rekommendation, och döpte
om vault-rubrikerna till bara "Vault"/`vault/` (utan undertitel).

## 2026-09-14 — Hyprland lua-config verifierad giltig

Körde `Hyprland --verify-config` mot `hypr/hyprland.lua` (riskfritt, startar ingen
compositor). Resultat: `config ok`, exit 0. Alla `.lua`-filer passerade även
`luac5.4 -p`. Se [[../03-felsokning/hyprland-lua-migration]] för detaljer — kvarstår
fortfarande att verifiera beteende i praktiken med en riktig reload.

## 2026-09-14 — Dotfiles-migrering till `~/dotfiles/`

- Flyttade all rice-config (`hypr`, `hypr.conf-backup-20260913`, `kitty`, `waybar`,
  `eww`, `rofi`, `swaync`, `wlogout`, `wob`, `cava`, `btop`, `fastfetch`,
  `starship.toml`, `~/.bashrc`, `rice.code-workspace`) från `~/.config`/`~` till
  `~/dotfiles/`, med symlinkar tillbaka på originalplatserna.
- **Varför:** köra Claude Code i hela `~/.config` exponerade orelaterade saker (gh-token,
  Firefox-profil, m.m.) — se resonemanget i chatthistoriken. Ett dedikerat
  git-versionerat dotfiles-repo med bara rice-relaterat innehåll är säkrare och ger
  historik/ångra.
- Verifierat: allt innehåll byte-identiskt efter flytt (md5sum, följt symlinkar med
  `-L`), inga trasiga symlinkar, alla körande processer (Hyprland, waybar, kitty, eww,
  swaync, cava) fortsatte köra opåverkade, `hyprctl configerrors` oförändrat tomt.
- Uppdaterade `rice.code-workspace` (flyttad in i repot) med alla mappar, inte bara de
  6 ursprungliga — samt waybar-knappen (`custom/hyprland-config`) som öppnar den.
- Upptäckte under tiden en pågående, ännu overifierad Hyprland lua-migrering — se
  [[../03-felsokning/hyprland-lua-migration]]. Rörde inget på WM-nivå.
- Skapade `CLAUDE.md` och den här `vault/`-strukturen.
- Git-repo initierat lokalt. **Ingen remote/push gjord** — Jakob gör det själv.
