#!/bin/bash
# Kun hanya menampilkan ikon. Redupkan saat Wi-Fi tidak tersambung.
source "$CONFIG_DIR/colors.sh"
if ipconfig getsummary en0 2>/dev/null | grep -q ' SSID : '; then
  sketchybar --set "$NAME" icon=󰖩 icon.color=$TEXT
else
  sketchybar --set "$NAME" icon=󰖪 icon.color=$MUTED  # nf-md-wifi_off
fi
