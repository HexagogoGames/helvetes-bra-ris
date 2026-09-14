# Tema / design

Genomgående mörk, "neon på natthimmel"-palett med JetBrainsMono Nerd Font.

## Färger (bekräftade i kitty + starship + hyprlock)

| Roll | Hex | Används i |
|---|---|---|
| Bakgrund | `#070910` | kitty, starship-segment |
| Text/förgrund | `#e8f1ff` | kitty, hyprlock-klocka |
| Accent 1 (cyan) | `#62e6ff` | starship directory-segment, hyprlock-klocka (rgba 232,241,255) |
| Accent 2 (lila) | `#a970ff` | starship git-segment |

`rofi/colors.rasi` har troligen samma palett — värdena är inte extraherade än, fyll i
här när de dubbelkollats.

## Font

**JetBrainsMono Nerd Font** genomgående (kitty, hyprlock).

## Formspråk (Hyprland)

- `rounding = 8` — mjukt rundade hörn
- `border_size = 2`
- `active_opacity = 1.0` / `inactive_opacity = 0.94`
- Blur: 2 passes, storlek 6, `ignore_opacity = true`
- Animationer: `easeOutCubic`/`easeInOutCubic`, popin 80% för fönster, slide för workspaces

## Wallpaper

`~/Bilder/Wallpapers/hyprland-nebula.png` — matchar palettens "nebulosa"-känsla.
