# Vault

Det här är ett kontinuerligt uppdaterat minne kring Jakobs Hyprland-rig: vad som är
konfigurerat, varför, vilka beslut som tagits, och kända problem. Skriv i vanlig
Markdown med `[[wikilänkar]]` — fungerar direkt om mappen öppnas som ett Obsidian-valv,
men kräver inte Obsidian för att vara användbar.

## Struktur

- **`00-oversikt/`** — helikoptervy: vilket system, vilken stack, hur allt hänger ihop.
- **`01-appar/`** — en not per program (Hyprland, kitty, waybar, ...): vad configen gör,
  viktiga inställningar, filstruktur.
- **`02-beslut/`** — logg över större beslut och ändringar (changelog-stil, nyast överst).
- **`03-felsokning/`** — dokumenterade problem och hur de löstes/löses. Sök hit först
  när något strular.
- **`04-tema/`** — färgpalett, typsnitt, estetiska val, så de går att återanvända.
- **`05-todo/`** — saker att göra/undersöka senare. Se särskilt
  [[05-todo/vantar-pa-jakob|vantar-pa-jakob.md]]: allt som kräver en åtgärd
  från Jakob själv (sudo, ett beslut, en bekräftelse) — inte bara idéer.

## Regel för uppdatering

Vaulten är bara värdefull om den hålls aktuell. Varje gång en config ändras på ett sätt
som spelar roll att komma ihåg (inte trivial finjustering) — uppdatera relevant not
eller lägg till en changelog-rad. Se [[../CLAUDE.md]] för detaljer.
