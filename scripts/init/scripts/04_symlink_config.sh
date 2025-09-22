#!/usr/bin/env bash

set -euo pipefail

log() {
    printf '\n-=> %s <=-\n' "$1"
}

log "创建 fastfetch 配置的符号链接..."
command rm -rf ~/.cache/fastfetch
command rm -rf ~/.config/fastfetch
ln -s ~/workspace/dev/mjj-config/fastfetch ~/.config/fastfetch

log "创建 fd 配置的符号链接..."
command rm -rf ~/.config/fd
ln -s ~/workspace/dev/mjj-config/fd ~/.config/fd

log "创建 hypr 配置的符号链接..."
command rm -rf ~/.config/hypr
ln -s ~/workspace/dev/mjj-config/hypr ~/.config/hypr

log "创建 kitty 配置的符号链接..."
command rm -rf ~/.config/kitty
ln -s ~/workspace/dev/mjj-config/kitty ~/.config/kitty

log "创建 mako 配置的符号链接..."
command rm -rf ~/.config/mako
ln -s ~/workspace/dev/mjj-config/mako ~/.config/mako

log "创建 mpv 配置的符号链接..."
command rm -rf ~/.config/mpv
ln -s ~/workspace/dev/mjj-config/mpv ~/.config/mpv

log "创建 navi 配置的符号链接..."
command rm -rf ~/.config/navi
ln -s ~/workspace/dev/mjj-config/navi ~/.config/navi

log "创建 nvim 配置的符号链接..."
command rm -rf \
        ~/.config/nvim \
        ~/.local/share/nvim \
        ~/.local/state/nvim \
        ~/.cache/nvim
ln -s ~/workspace/dev/mjj-config/nvim ~/.config/nvim

log "创建 rofi 配置的符号链接..."
command rm -rf ~/.config/rofi
ln -s ~/workspace/dev/mjj-config/rofi ~/.config/rofi

log "创建 waybar 配置的符号链接..."
command rm -rf ~/.config/waybar
ln -s ~/workspace/dev/mjj-config/waybar ~/.config/waybar

log "创建 yt-dlp 配置的符号链接..."
command rm -rf ~/.config/yt-dlp
ln -s ~/workspace/dev/mjj-config/yt-dlp ~/.config/yt-dlp
