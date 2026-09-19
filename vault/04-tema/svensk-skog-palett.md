# Svensk skog — paletten

Det officiella namnet på riggens färgschema, bestämt 2026-09-14/15. Extraherad
ur Jakobs egen wallpaper (`images/backgrounds/forrest-background1.png`, se
[[../02-beslut/changelog]]) med `magick ... -colors 12 -unique-colors` istället
för gissade gröna toner — sedan finjusterad för kontrast/läsbarhet.

## Färgtabell

| Roll | Hex | Används till | Källa |
|---|---|---|---|
| Bakgrund | `#17211a` | Fönster-/panel-botten överallt | mörkaste skuggtonen i fotot |
| Yta | `#333724` | Paneler, rofi-element, kort | mossgrön mellanton (se nedan) |
| Text | `#ece3c6` | All brödtext | varm krämvit, "solljus genom lövverk" |
| Text (dämpad) | `#93a08c` | Sekundär text, inaktiva ikoner | gråaktig salvia/mossgrå ur fotot |
| **Border** | `#404437` | **Bara kant-egenskaper** (aktiv fönsterkant, toggle-kanter, input-ringar) | mörkare, mindre mättad mossgrön — medvetet skild från Accent 1 |
| Accent 1 (guld) | `#d4a24a` | Highlights, aktiv text/ikon, fyllda toggle-brickor, klocka | uppjusterad från fotots solbelysta ockra |
| Accent 2 (moss green) | `#8a9a5b` | Sekundära highlights, workspace-dots (inaktiva) | **referensvärdet för "moss green" självt**, se nedan |
| Röd | `#c1543f` | Varning/kritiskt/destruktiva knappar | rostig tegel-röd, matchar jordton-familjen |
| Grön (status) | `#adbc80` | "Ok"/laddar-status, skild från Accent 2 | ljusare mossgrön |

**Viktig regel:** Border (`#404437`) används *bara* för kant-egenskaper
(`border`, `border-color`, `outer_color` i hyprlock osv) — aldrig för
fyllningar, text eller ikoner. De använder Accent 1/2 istället. Beslutat
2026-09-14 när Jakob bytte bort guld-kanter mot gröna.

## Den gröna identiteten: "Moss green" (beslutat 2026-09-19)

Jakob har bestämt att paletten inte bara ska beskrivas som "grönt
skogstema" rent allmänt — den korrekta, namngivna gröna tonen är
**mossgrön ("moss green")**. Verifierad referens (flera oberoende
källor: htmlcolorcodes.com, color-name.com, rgbcolorpedia/encycolorpedia
sammanfaller): `#8A9A5B` — en dämpad, gulaktig grön, tydligt skild från
en blådoftande skogsgrön eller en klar lövgrön.

**Genomfört samma dag:** "om något är i färgen grön kan du ändra det till
moss green." Alla gröna toner i tabellen ovan (och i hela riggen, se
nedan) är omräknade som en sammanhängande familj utifrån `#8A9A5B`
(samma nyans/mättnad, bara varierande ljushet per roll — beräknat i
HLS-rymden, inte bara ögonmått): Accent 2 är referensen själv, Grön
(status) en ljusare variant, Yta och Border mörkare/dämpade varianter.
De gamla värdena (`#7fa66b`, `#8fbf6f`, `#2c3a2e`, `#3f5c42`) lutade mer
mot blågrön/klar lövgrön.

**Dynamiskt tema (wallust) — "löst" följer bakgrundsbilden:** Jakob ville
fortfarande att temat ska följa bakgrundsbilden, åtminstone löst. Den
"gröna" rollen i `wallust/templates/*` (används för icke-ankarbilder)
använder nu wallusts `blend("8a9a5b")`-filter: den extraherade grönton
ur *just den bilden* blandas 50/50 med mossgrönt-referensen, istället
för att antingen vara helt fri (ingen koppling till moss green) eller
helt låst (ingen koppling till bilden). Se [[dynamiskt-tema]].

## Var paletten är implementerad

Hyprland (`hyprland.lua`, `rules.lua`), kitty, waybar, rofi, swaync, wlogout,
hyprlock, btop (`forest.theme`), fastfetch, starship, cava, wob, eww — dvs
hela riggen. Se [[design]] för implementationshistorik och beslutslogg.

## Framtida användning

Jakob vill att **det mesta ska matcha den här paletten** framöver, inte bara
det som redan är gjort. Nästa kända kandidat: ett eget Spicetify-tema för
Spotify (se [[../05-todo/wishlist]]) ska byggas mot exakt dessa hex-värden,
inte ett fristående community-tema.
