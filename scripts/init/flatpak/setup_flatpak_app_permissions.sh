#!/usr/bin/env bash

# 设置严格模式，任何错误都会导致脚本退出
set -euo pipefail

log() {
    printf '\n-=> %s <=-\n' "$1"
}

# 1. 撤销权限

# 或者直接去这里删除:
# command rm -rfv ~/.local/share/flatpak/overrides

flatpak override --user --reset md.obsidian.Obsidian
flatpak override --user --reset org.localsend.localsend_app
flatpak override --user --reset io.github.ungoogled_software.ungoogled_chromium
flatpak override --user --reset org.telegram.desktop
flatpak override --user --reset io.mgba.mGBA

# 2. 设置权限
flatpak override --user md.obsidian.Obsidian --env=GTK_IM_MODULE=fcitx

flatpak override --user org.localsend.localsend_app \
    --filesystem=xdg-videos \
    --filesystem=xdg-pictures \
    --filesystem=xdg-documents \
    --filesystem=~/workspace \
    --filesystem=/workspace \
    --filesystem=/data

flatpak override --user io.github.ungoogled_software.ungoogled_chromium \
    --filesystem=xdg-videos \
    --filesystem=xdg-pictures \
    --filesystem=xdg-documents \
    --filesystem=~/workspace \
    --filesystem=/workspace \
    --filesystem=/data

flatpak override --user org.telegram.desktop \
    --filesystem=/data

flatpak override --user io.mgba.mGBA \
    --filesystem=/data
