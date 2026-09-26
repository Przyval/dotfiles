#!/bin/bash
# Persentase RAM terpakai = 100 - persentase bebas versi memory_pressure.
FREE=$(memory_pressure | awk -F': ' '/System-wide memory free percentage/ {gsub("%","",$2); print $2}')
sketchybar --set "$NAME" label="$((100 - ${FREE:-100}))%"
