# Dotfiles — agent guide

GNU Stow-based dotfiles. Each top-level dir is a stow package mirroring `$HOME`
paths (`tmux/.config/tmux/…` → `~/.config/tmux/…`). `setup.sh` bootstraps a
fresh machine: brew installs, `stow "$dir" -t "$HOME"` for every package,
then herdr plugin installs. `.kimchi/` (agent working docs) is gitignored.

Claude Code's own config is stow-managed too, under `claude/.claude/…`. A
hand-authored skill/command/agent goes there (`claude/.claude/skills|commands|agents/<name>/`),
then `stow claude -t "$HOME"` — same flow as any other tool here.

## Working agreements
- No commits until user asks
- `~/.claude/settings.json` is safe to commit (shared config, no secrets) via
  `claude/.claude/settings.json` — never `.claude/.credentials.json` (auth
  tokens) or `.claude/settings.local.json` (machine-local overrides by
  Claude Code's own convention); neither belongs in dotfiles
- Cross-OS: macOS + desktop Linux; scripts must degrade gracefully elsewhere
