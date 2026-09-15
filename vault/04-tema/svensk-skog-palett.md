# Svensk skog — paletten

Det officiella namnet på riggens färgschema, bestämt 2026-09-14/15. Extraherad
ur Jakobs egen wallpaper (`images/backgrounds/forrest-background1.png`, se
[[../02-beslut/changelog]]) med `magick ... -colors 12 -unique-colors` istället
för gissade gröna toner — sedan finjusterad för kontrast/läsbarhet.

## Färgtabell

| Roll | Hex | Används till | Källa |
|---|---|---|---|
| Bakgrund | `#17211a` | Fönster-/panel-botten överallt | mörkaste skuggtonen i fotot |
| Yta | `#2c3a2e` | Paneler, rofi-element, kort | mossgrön mellanton |
| Text | `#ece3c6` | All brödtext | varm krämvit, "solljus genom lövverk" |
| Text (dämpad) | `#93a08c` | Sekundär text, inaktiva ikoner | gråaktig salvia/mossgrå ur fotot |
| **Border** | `#3f5c42` | **Bara kant-egenskaper** (aktiv fönsterkant, toggle-kanter, input-ringar) | mörkare, mindre mättad grön — medvetet skild från Accent 1 |
| Accent 1 (guld) | `#d4a24a` | Highlights, aktiv text/ikon, fyllda toggle-brickor, klocka | uppjusterad från fotots solbelysta ockra |
| Accent 2 (löv-grön) | `#7fa66b` | Sekundära highlights, workspace-dots (inaktiva) | livligare grön än fotots dämpade toner |
| Röd | `#c1543f` | Varning/kritiskt/destruktiva knappar | rostig tegel-röd, matchar jordton-familjen |
| Grön (status) | `#8fbf6f` | "Ok"/laddar-status, skild från Accent 2 | ljusare löv-grön |

**Viktig regel:** Border (`#3f5c42`) används *bara* för kant-egenskaper
(`border`, `border-color`, `outer_color` i hyprlock osv) — aldrig för
fyllningar, text eller ikoner. De använder Accent 1/2 istället. Beslutat
2026-09-14 när Jakob bytte bort guld-kanter mot gröna.

## Var paletten är implementerad

Hyprland (`hyprland.lua`, `rules.lua`), kitty, waybar, rofi, swaync, wlogout,
hyprlock, btop (`forest.theme`), fastfetch, starship, cava, wob, eww — dvs
hela riggen. Se [[design]] för implementationshistorik och beslutslogg.

## Framtida användning

Jakob vill att **det mesta ska matcha den här paletten** framöver, inte bara
det som redan är gjort. Nästa kända kandidat: ett eget Spicetify-tema för
Spotify (se [[../05-todo/wishlist]]) ska byggas mot exakt dessa hex-värden,
inte ett fristående community-tema.
