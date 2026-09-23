# Dotfiles — agent guide

GNU Stow-based dotfiles. Each top-level dir is a stow package mirroring `$HOME`
paths (`tmux/.config/tmux/…` → `~/.config/tmux/…`). `setup.sh` bootstraps a
fresh machine: brew installs, `stow "$dir" -t "$HOME"` for every package,
then herdr plugin installs. `.kimchi/` (agent working docs) is gitignored.

Claude Code's own config is stow-managed too, under `claude/.claude/…`. A
hand-authored skill/command/agent goes there (`claude/.claude/skills|commands|agents/<name>/`),
then `stow claude -t "$HOME"` — same flow as any other tool here.

Kimchi's global config follows the same pattern under
`kimchi/.config/kimchi/harness/…` (settings + pi-style extensions), stowed so
files land in `~/.config/kimchi/harness/…`. Machine/project-local state
(`.kimchi/` in a repo, auth tokens, `~/.config/kimchi/harness/extensions/herdr-agent-state.ts`
— installed and owned by herdr) is NOT tracked.

herdr plan-annotator integration (plannotator pane is the annotation gate):
- Claude: `claude/.claude/hooks/open-plan-in-annotator.sh` (PreToolUse on
  ExitPlanMode, timeout 3600s) opens the newest `.claude/plans/*.md` in an
  80/20 top-split annotate pane and blocks, polling
  `~/.plannotator/feedback/<project>/index.jsonl`.
- Kimchi: `kimchi/.config/kimchi/harness/extensions/herdr-plan-annotator.ts`
  does the same for the `submit_plan` tool and `.kimchi/plans/*.md`;
  "feedback" returns `{block, reason}`.
- Both: a "feedback" record denies/blocks with the annotation text; closing
  the pane with nothing sent makes no decision, so the agent's native review
  UI appears (explicit approval happens there). NOTE: plannotator-tui
  (bundled 0.8.0, still true in 0.9.x) emits ONLY `decision: "feedback"` on
  Send — the "approve" record branch exists in both integrations but never
  fires until the TUI gains an approval gate (the browser app's `--gate`
  only). The pane is therefore an annotation/request-changes gate today;
  both integrations additionally treat an all-👍 looks-good record (no
  comments/deletes) as an implicit approval.
- herdr `prefix+p` runs `claude/.claude/hooks/reopen-plan-in-annotator.sh`,
  which reopens the newest plan across BOTH agents' plan dirs.

## Working agreements
- No commits until user asks
- `~/.claude/settings.json` is safe to commit (shared config, no secrets) via
  `claude/.claude/settings.json` — never `.claude/.credentials.json` (auth
  tokens) or `.claude/settings.local.json` (machine-local overrides by
  Claude Code's own convention); neither belongs in dotfiles
- `~/.config/kimchi/harness/settings.json` is likewise safe to commit via
  `kimchi/.config/kimchi/harness/settings.json` — never
  `~/.config/kimchi/{config.json,harness/auth.json,harness/trust.json}`
  (API keys, session/runtime trust state); those stay machine-local
- Cross-OS: macOS + desktop Linux; scripts must degrade gracefully elsewhere
