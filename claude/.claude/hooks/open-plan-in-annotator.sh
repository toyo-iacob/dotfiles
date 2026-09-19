#!/usr/bin/env bash
# PreToolUse hook for ExitPlanMode: when Claude presents a finished plan,
# open it in the herdr "annotate" plugin pane so it's ready to review
# without pressing prefix+o (which only browses cwd, unaware of the plan).
set -euo pipefail

# Only useful inside herdr, with the annotate plugin available.
[ -n "${HERDR_PANE_ID:-}" ] || exit 0
command -v herdr >/dev/null 2>&1 || exit 0

input="$(cat)"
cwd="$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null || true)"
[ -n "$cwd" ] || exit 0

plans_dir="$cwd/.claude/plans"
[ -d "$plans_dir" ] || exit 0

plan_file="$(ls -t "$plans_dir"/*.md 2>/dev/null | head -1 || true)"
[ -n "$plan_file" ] || exit 0

# Close any stale annotate pane left over from a previous ExitPlanMode call
# for this same Claude pane, so repeated calls don't pile up duplicate panes.
if [ -n "${HERDR_WORKSPACE_ID:-}" ] && [ -n "${HERDR_TAB_ID:-}" ]; then
  stale_panes="$(herdr pane list --workspace "$HERDR_WORKSPACE_ID" 2>/dev/null \
    | jq -r --arg tab "$HERDR_TAB_ID" --arg cwd "$cwd" \
        '.result.panes[]? | select(.tab_id == $tab and .label == "Annotate" and .cwd == $cwd) | .pane_id' \
      2>/dev/null || true)"
  if [ -n "$stale_panes" ]; then
    printf '%s\n' "$stale_panes" | while IFS= read -r pane_id; do
      [ -n "$pane_id" ] && herdr plugin pane close "$pane_id" >/dev/null 2>&1 || true
    done
  fi
fi

herdr plugin pane open --plugin annotate --entrypoint doc --placement split \
  --direction right --target-pane "$HERDR_PANE_ID" --focus --cwd "$cwd" \
  --env "PLANNOTATOR_TUI_FILE=$plan_file" \
  --env "PLANNOTATOR_TUI_DELIVER_TO=$HERDR_PANE_ID" >/dev/null 2>&1 || true

exit 0
