#!/bin/bash
# Nomor workspace AeroSpace yang aktif. Saat event datang, AeroSpace
# mengirim FOCUSED_WORKSPACE; saat bar baru dimuat, tanya AeroSpace langsung.
FOCUSED="${FOCUSED_WORKSPACE:-$(/opt/homebrew/bin/aerospace list-workspaces --focused 2>/dev/null)}"
sketchybar --set "$NAME" label="${FOCUSED:-?}"
