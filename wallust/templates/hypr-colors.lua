-- Genererad av wallust ur aktuell bakgrundsbild - redigera inte för hand,
-- skrivs över vid nästa bakgrundsbyte. Källa: wallust/templates/hypr-colors.lua.
-- Se vault/04-tema/dynamiskt-tema.md.
return {
    active_border = "rgba({{ color8 | strip }}ff)",
    inactive_border = "rgba({{ foreground | darken(0.35) | strip }}33)",
}
