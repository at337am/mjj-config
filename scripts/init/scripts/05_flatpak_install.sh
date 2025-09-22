#!/usr/bin/env bash

set -euo pipefail

log() {
    printf '\n-=> %s <=-\n' "$1"
}

log "设置 flathub 仓库..."

sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo

log "安装常用 Flatpak App..."

command flatpak install -y flathub md.obsidian.Obsidian

command flatpak install -y flathub org.localsend.localsend_app

command flatpak install -y flathub io.github.ungoogled_software.ungoogled_chromium

command flatpak install -y flathub org.telegram.desktop

command flatpak install -y flathub io.mgba.mGBA

log "常用 Flatpak App 已安装完毕..."
