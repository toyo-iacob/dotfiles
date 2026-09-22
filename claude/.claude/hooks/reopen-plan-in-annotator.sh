#!/usr/bin/env bash
# herdr keybinding (prefix+shift+p): reopen the latest plan for the active
# pane's cwd in the herdr "annotate" plugin — e.g. after closing the pane
# that open-plan-in-annotator.sh opened automatically on ExitPlanMode.
#
# Shell key-commands run detached (no stdin, no /dev/tty): herdr provides
# HERDR_ACTIVE_PANE_ID / HERDR_ACTIVE_WORKSPACE_ID instead of the
# HERDR_PANE_ID / cwd-on-stdin that the ExitPlanMode hook gets.
set -euo pipefail

command -v herdr >/dev/null 2>&1 || exit 0
command -v jq >/dev/null 2>&1 || exit 0

pane_id="${HERDR_ACTIVE_PANE_ID:-}"
workspace_id="${HERDR_ACTIVE_WORKSPACE_ID:-}"
[ -n "$pane_id" ] && [ -n "$workspace_id" ] || exit 0

pane_info="$(herdr pane list --workspace "$workspace_id" 2>/dev/null \
  | jq -c --arg id "$pane_id" '.result.panes[]? | select(.pane_id == $id)' 2>/dev/null || true)"
[ -n "$pane_info" ] || exit 0

cwd="$(printf '%s' "$pane_info" | jq -r '.cwd // empty')"
tab_id="$(printf '%s' "$pane_info" | jq -r '.tab_id // empty')"
[ -n "$cwd" ] && [ -n "$tab_id" ] || exit 0

plans_dir="$cwd/.claude/plans"
[ -d "$plans_dir" ] || exit 0

plan_file="$(ls -t "$plans_dir"/*.md 2>/dev/null | head -1 || true)"
[ -n "$plan_file" ] || exit 0

# Close any existing annotate pane for this Claude pane before reopening,
# same dedup rule as open-plan-in-annotator.sh.
stale_panes="$(herdr pane list --workspace "$workspace_id" 2>/dev/null \
  | jq -r --arg tab "$tab_id" --arg cwd "$cwd" \
      '.result.panes[]? | select(.tab_id == $tab and .label == "Annotate" and .cwd == $cwd) | .pane_id' \
    2>/dev/null || true)"
if [ -n "$stale_panes" ]; then
  printf '%s\n' "$stale_panes" | while IFS= read -r sp; do
    [ -n "$sp" ] && herdr plugin pane close "$sp" >/dev/null 2>&1 || true
  done
fi

open_result="$(herdr plugin pane open --plugin annotate --entrypoint doc --placement split --direction down \
  --target-pane "$pane_id" --focus --cwd "$cwd" \
  --env "PLANNOTATOR_TUI_FILE=$plan_file" \
  --env "PLANNOTATOR_TUI_DELIVER_TO=$pane_id" 2>/dev/null || true)"

annotate_pane_id="$(printf '%s' "$open_result" | jq -r '.result.plugin_pane.pane.pane_id // empty' 2>/dev/null || true)"
if [ -n "$annotate_pane_id" ]; then
  herdr pane swap --pane "$annotate_pane_id" --direction up >/dev/null 2>&1 || true
  herdr pane resize --pane "$annotate_pane_id" --direction down --amount 0.3 >/dev/null 2>&1 || true
fi

exit 0
