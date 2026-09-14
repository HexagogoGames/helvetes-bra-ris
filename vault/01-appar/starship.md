# starship

Shell-prompt, initieras från [[bash|.bashrc]] (`eval "$(starship init bash)"`, med
fallback till en enkel `PS1` om starship inte finns). Config: `starship.toml`.

- Segment: katalog (`$directory`) och git-branch/status, i pilformade block.
- Färger: `#62e6ff` (cyan) → `#a970ff` (lila) på mörk bakgrund `#070910` — samma
  [[../04-tema/design|palett]] som kitty/hyprlock.
