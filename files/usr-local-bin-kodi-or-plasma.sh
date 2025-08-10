#!/usr/bin/env bash
set -euo pipefail
STATE="${HOME}/.local/state/kodi-mode"
mkdir -p "$(dirname "$STATE")"
[[ -s "$STATE" ]] || echo kodi > "$STATE"

while true; do
  mode="$(cat "$STATE" 2>/dev/null || echo kodi)"
  if [[ "$mode" = "kodi" ]]; then
    /usr/bin/kodi-standalone || true
    echo plasma > "$STATE"
  else
    if command -v startplasma-wayland >/dev/null 2>&1; then
      /usr/bin/dbus-run-session /usr/bin/startplasma-wayland || true
    elif command -v startx >/dev/null 2>&1; then
      /usr/bin/startx /usr/bin/startplasma-x11 -- :0 vt1 -keeptty || true
    else
      /usr/bin/startplasma-x11 || true
    fi
    echo kodi > "$STATE"
  fi
  sleep 1
done
