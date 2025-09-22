#!/usr/bin/env bash

set -euo pipefail

log() {
    printf '\n-=> %s <=-\n' "$1"
}

# 1. 撤销权限

# 或者直接去这里删除:
# command rm -rfv ~/.local/share/flatpak/overrides

command flatpak override --user --reset md.obsidian.Obsidian
command flatpak override --user --reset org.localsend.localsend_app
command flatpak override --user --reset io.github.ungoogled_software.ungoogled_chromium
command flatpak override --user --reset org.telegram.desktop
command flatpak override --user --reset io.mgba.mGBA

# 2. 设置权限
command flatpak override --user md.obsidian.Obsidian --env=GTK_IM_MODULE=fcitx

command flatpak override --user org.localsend.localsend_app \
    --filesystem=xdg-videos \
    --filesystem=xdg-pictures \
    --filesystem=xdg-documents \
    --filesystem=~/workspace \
    --filesystem=/workspace \
    --filesystem=/data

command flatpak override --user io.github.ungoogled_software.ungoogled_chromium \
    --filesystem=xdg-videos \
    --filesystem=xdg-pictures \
    --filesystem=xdg-documents \
    --filesystem=~/workspace \
    --filesystem=/workspace \
    --filesystem=/data

command flatpak override --user org.telegram.desktop \
    --filesystem=/data

command flatpak override --user io.mgba.mGBA \
    --filesystem=/data
