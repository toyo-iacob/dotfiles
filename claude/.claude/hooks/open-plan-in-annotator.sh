#!/usr/bin/env bash
# PreToolUse hook for ExitPlanMode: opens the plan in the herdr "annotate"
# pane and blocks until the human decides, so plannotator is the sole review
# UI for this call. Claude's own native plan-approval prompt only appears if
# this hook exits without a decision (see below) — it never races the
# annotate pane while this hook is still running.
#
# Decision channel: plannotator-tui writes a delivery record to
# ~/.plannotator/feedback/<project>/index.jsonl every time Send is pressed —
# one JSON line per send, with an explicit "decision" field ("feedback" or
# "approve"), the target file path, and (for feedback) the fully formatted
# annotation text. That's deterministic regardless of whether pane-injection
# or clipboard delivery would otherwise succeed, so this hook polls that log
# instead of relying on either. It responds the moment a matching record
# shows up — no need to also close the pane first.
#
# If the pane is closed with no matching record (nothing sent), this hook
# makes no decision at all and exits quietly, so Claude's native approval
# prompt appears and the human explicitly approves there. This hook never
# auto-approves a plan except via an explicit "approve" record.
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

feedback_log="$HOME/.plannotator/feedback/$(basename "$cwd")/index.jsonl"
lines_before=0
[ -f "$feedback_log" ] && lines_before="$(wc -l < "$feedback_log" | tr -d ' ')"

open_result="$(herdr plugin pane open --plugin annotate --entrypoint doc --placement split --direction down \
  --target-pane "$HERDR_PANE_ID" --focus --cwd "$cwd" \
  --env "PLANNOTATOR_TUI_FILE=$plan_file" 2>/dev/null || true)"

annotate_pane_id="$(printf '%s' "$open_result" | jq -r '.result.plugin_pane.pane.pane_id // empty' 2>/dev/null || true)"
[ -n "$annotate_pane_id" ] || exit 0

# Split opens 50/50 with the new pane below the target. Swap it above the
# Claude pane, then grow it to 80% height (default split ratio is 0.5, so
# +0.3 lands at 0.8).
herdr pane swap --pane "$annotate_pane_id" --direction up >/dev/null 2>&1 || true
herdr pane resize --pane "$annotate_pane_id" --direction down --amount 0.3 >/dev/null 2>&1 || true

# Poll for either a new matching delivery record, or the pane closing.
while true; do
  if [ -f "$feedback_log" ]; then
    new_records="$(tail -n "+$((lines_before + 1))" "$feedback_log" 2>/dev/null \
      | jq -c --arg file "$plan_file" 'select(.target.filePath == $file)' 2>/dev/null || true)"
    if [ -n "$new_records" ]; then
      decision="$(printf '%s\n' "$new_records" | jq -r '.decision' | tail -1)"
      if [ "$decision" = "approve" ]; then
        printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow"}}\n'
        exit 0
      fi
      if [ "$decision" = "feedback" ]; then
        combined="$(printf '%s\n' "$new_records" | jq -s -r 'map(.feedback) | join("\n")')"
        reason="$(printf '%s' "$combined" | jq -Rs .)"
        printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":%s}}\n' "$reason"
        exit 0
      fi
    fi
  fi

  herdr pane get "$annotate_pane_id" >/dev/null 2>&1 || exit 0
  sleep 0.3
done
