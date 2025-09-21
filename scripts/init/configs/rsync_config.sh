#!/usr/bin/env bash

# 设置严格模式，任何错误都会导致脚本退出
set -euo pipefail

log() {
    echo "-=> $1 <=-"
}

log "同步 fontconfig 配置..."
rsync -a ~/workspace/dev/mjj-config/fontconfig/ ~/.config/fontconfig/

log "刷新 font 字体缓存..."
fc-cache -f

log "同步 gitconfig 配置..."
rsync -a ~/workspace/dev/mjj-config/gitconfig/.gitconfig ~/

log "设置 gitconfig 文件权限..."
chmod 600 ~/.gitconfig

log "同步 ssh config 配置..."
rsync -a ~/workspace/dev/mjj-config/ssh/config ~/.ssh/

log "设置 ssh 文件权限..."
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
