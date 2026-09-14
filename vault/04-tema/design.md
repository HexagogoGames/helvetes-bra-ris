# Tema / design

## 🚧 Temaomdesign pågår (påbörjad 2026-09-14)

Allt under "Tidigare placeholder-tema" nedan var provisoriskt — Jakob bestämde
2026-09-14 att designen ska tas om från grunden, medvetet, del för del. Använde
[[../05-todo/temaverkstad|Riggsmedjan]] (interaktiv Artifact, källa:
`vault/05-todo/temaverkstad.html`) för att utforska estetik/färg/mättnad live innan
beslut.

### Beslutat hittills

**Estetik: Vibrant.** Mättade accentfärger, rounding 14px, `border_size = 3`,
`gaps_in = 8` / `gaps_out = 12`, lätt blur (size 3, passes 1),
`active_opacity = 0.97` / `inactive_opacity = 0.78`. Fokuserat fönster tänkt att få
en roterande gradient-kant (accent → accent2 → accent, animerad) snarare än en
statisk kantfärg — **oklart ännu om det ska implementeras skarpt i Hyprland eller om
det bara var mockup-smek; fråga kvar.**

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

### Kvar att bestämma (fylls i allt eftersom)
- [ ] Waybar-layout (position, modulgruppering, workspace-indikatorstil, vilka moduler)
- [x] ~~Wallpaper~~ — **Jakobs eget beslut, inte del av frågerundorna.** Bekräftat:
      verktyg blir **hyprpaper** (byte från `swaybg`, som är vad som faktiskt kör just
      nu, se [[../01-appar/hyprland]]/`ps aux`). Vilken bild och hur den konfigureras
      bestämmer Jakob själv och meddelar när det är klart.
- [ ] Animationer (fönster öppna/stäng-stil, workspace-switch, hastighet/personlighet)
- [ ] Gradient-kant på fokuserat fönster: verklig Hyprland-effekt eller bara mockup?
- [ ] Rofi-layout (lista/grid, position)
- [ ] Notiser (swaync): position, stil
- [ ] Cursor-tema + storlek
- [ ] hyprlock-stil
- [ ] wlogout-layout (ikon-set, bekräftelsedialoger)
- [ ] btop/fastfetch/cava/starship — matcha samma Gruvbox-palett

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
