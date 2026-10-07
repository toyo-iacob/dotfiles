#!/bin/sh
# One-line weather for the herdr tab bar (replaces xamut/tmux-weather).
# Same data source as that plugin: wttr.in. Empty output on failure so a
# network blip just hides the segment instead of showing garbage.

cache="/tmp/herdr-weather.txt"
max_age=900 # 15 min; herdr re-runs the command per interval_seconds anyway

if [ -f "$cache" ] && [ $(( $(date +%s) - $(stat -f %m "$cache") )) -lt "$max_age" ]; then
  cat "$cache"
  exit 0
fi

out=$(curl -fsS --max-time 3 "https://wttr.in/?format=%c+%t" 2>/dev/null)
if [ -n "$out" ]; then
  printf '%s' "$out" | tee "$cache"
else
  [ -f "$cache" ] && cat "$cache"
fi
