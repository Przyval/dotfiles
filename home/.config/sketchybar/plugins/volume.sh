#!/bin/bash
# Event volume_change mengirim volume baru di $INFO.
VOLUME="${INFO:-$(osascript -e 'output volume of (get volume settings)')}"
case "$VOLUME" in
  0|"") ICON= ;;  # nf-fa-volume_off
  *) ICON= ;;     # nf-fa-volume_down, glyph yang dipakai Kun
esac
sketchybar --set "$NAME" icon="$ICON" label="${VOLUME}%"
