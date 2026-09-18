# Dotfiles — agent guide

GNU Stow-based dotfiles. Each top-level dir is a stow package mirroring `$HOME`
paths (`tmux/.config/tmux/…` → `~/.config/tmux/…`). `setup.sh` bootstraps a
fresh machine: brew installs, `stow "$dir" -t "$HOME"` for every package,
then herdr plugin installs. `.kimchi/` (agent working docs) is gitignored.

## Working agreements
- No commits until user asks; never commit `~/.claude/settings.json` (secrets)
- Cross-OS: macOS + desktop Linux; scripts must degrade gracefully elsewhere
