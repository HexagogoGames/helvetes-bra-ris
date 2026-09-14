# Changelog

Nyast överst.

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
