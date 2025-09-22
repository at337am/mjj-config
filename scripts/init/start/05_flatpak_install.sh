#!/usr/bin/env bash

# 设置严格模式，任何错误都会导致脚本退出
set -euo pipefail

log() {
    printf '\n-=> %s <=-\n' "$1"
}

log "设置 flathub 仓库..."

sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo

log "安装常用 Flatpak App..."

flatpak install -y flathub md.obsidian.Obsidian

flatpak install -y flathub org.localsend.localsend_app

flatpak install -y flathub io.github.ungoogled_software.ungoogled_chromium

flatpak install -y flathub org.telegram.desktop

flatpak install -y flathub io.mgba.mGBA

log "常用 Flatpak App 已安装完毕..."
