#!/bin/sh
# Guarded close-pane for herdr (bound to prefix+x as a custom command).
# Closes the active pane — unless it is the last pane of the workspace,
# in which case it refuses and pings. Use prefix+alt+x to force-close.
#
# Runs detached (type=shell); env provides HERDR_ACTIVE_WORKSPACE_ID /
# HERDR_ACTIVE_PANE_ID / HERDR_BIN_PATH when available.

BIN="${HERDR_BIN_PATH:-herdr}"
PANE="$HERDR_ACTIVE_PANE_ID"
WS="$HERDR_ACTIVE_WORKSPACE_ID"

[ -n "$PANE" ] || exit 0

if [ -n "$WS" ]; then
  count=$("$BIN" workspace list 2>/dev/null | python3 -c '
import json, sys
try:
    ws = sys.argv[1]
    for w in json.load(sys.stdin)["result"]["workspaces"]:
        if w["workspace_id"] == ws:
            print(w["pane_count"])
            break
except Exception:
    print(-1)
' "$WS")

  if [ "$count" = "1" ]; then
    # Last pane: refuse and ping instead of nuking the workspace.
    # herdr shell commands run detached (no /dev/tty), so play via OS audio:
    # afplay on macOS, paplay (pulse/pipewire) on Linux.
    if command -v afplay >/dev/null 2>&1; then
      afplay /System/Library/Sounds/Funk.aiff >/dev/null 2>&1 &
    elif command -v paplay >/dev/null 2>&1; then
      paplay /usr/share/sounds/freedesktop/stereo/bell.oga >/dev/null 2>&1 &
    fi
    exit 0
  fi
fi

exec "$BIN" pane close "$PANE"
