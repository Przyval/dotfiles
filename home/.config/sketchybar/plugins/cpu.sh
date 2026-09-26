#!/bin/bash
# Kun menampilkan beban rata-rata 1 menit (mis. "3.82"), bukan persen.
LOAD=$(sysctl -n vm.loadavg | awk '{print $2}')
sketchybar --set "$NAME" label="$LOAD"
