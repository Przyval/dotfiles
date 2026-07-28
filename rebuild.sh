#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles
# sudo mereset PATH ke default aman yang TIDAK memuat /run/current-system/sw/bin,
# sehingga `sudo darwin-rebuild` gagal "command not found" meski binernya ada.
# bootstrap.sh menyiasati ini untuk `nix`; rebuild.sh aslinya tidak.
DR="/run/current-system/sw/bin/darwin-rebuild"
[ -x "$DR" ] || DR="$(command -v darwin-rebuild)"
exec sudo "$DR" switch --flake ~/.dotfiles#mac
