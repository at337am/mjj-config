#!/usr/bin/env bash

# 设置严格模式，任何错误都会导致脚本退出
set -euo pipefail

log() {
    echo "-=> $1 <=-"
}

command rm -rf ~/.cache/fastfetch
command rm -rf ~/.config/fastfetch
ln -s ~/workspace/dev/mjj-config/fastfetch ~/.config/fastfetch
log "fastfetch 配置已链接"

command rm -rf ~/.config/fd
ln -s ~/workspace/dev/mjj-config/fd ~/.config/fd
log "fd 配置已链接"

command rm -rf ~/.config/hypr
ln -s ~/workspace/dev/mjj-config/hypr ~/.config/hypr
log "hypr 配置已链接"

command rm -rf ~/.config/kitty
ln -s ~/workspace/dev/mjj-config/kitty ~/.config/kitty
log "kitty 配置已链接"

command rm -rf ~/.config/mako
ln -s ~/workspace/dev/mjj-config/mako ~/.config/mako
log "mako 配置已链接"

command rm -rf ~/.config/mpv
ln -s ~/workspace/dev/mjj-config/mpv ~/.config/mpv
log "mpv 配置已链接"

command rm -rf ~/.config/navi
ln -s ~/workspace/dev/mjj-config/navi ~/.config/navi
log "navi 配置已链接"

command rm -rf \
        ~/.config/nvim \
        ~/.local/share/nvim \
        ~/.local/state/nvim \
        ~/.cache/nvim
ln -s ~/workspace/dev/mjj-config/nvim ~/.config/nvim
log "nvim 配置已链接"

command rm -rf ~/.config/rofi
ln -s ~/workspace/dev/mjj-config/rofi ~/.config/rofi
log "rofi 配置已链接"

command rm -rf ~/.config/waybar
ln -s ~/workspace/dev/mjj-config/waybar ~/.config/waybar
log "waybar 配置已链接"

command rm -rf ~/.config/yt-dlp
ln -s ~/workspace/dev/mjj-config/yt-dlp ~/.config/yt-dlp
log "yt-dlp 配置已链接"
