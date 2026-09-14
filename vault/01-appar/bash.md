# bash (.bashrc)

Nu `dotfiles/bashrc`, symlinkad till `~/.bashrc`.

- Moderna CLI-ersättare, med fallback om inte installerat: `eza` (ls/ll/la/lt med
  ikoner), `bat` (cat med paging av), `zoxide` (`cd` → `z`).
- `fzf` key-bindings/completion laddas från `/usr/share/fzf/`.
- `SSH_AUTH_SOCK` pekas till `$XDG_RUNTIME_DIR/ssh-agent.socket` (matchar `ssh-add` i
  [[hyprland|Hyprlands autostart]]).
- [[starship|starship]]-prompt initieras sist, med enkel `PS1`-fallback.
