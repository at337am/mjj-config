#!/usr/bin/env bash

# 设置严格模式，任何错误都会导致脚本退出
set -euo pipefail

log() {
    echo "-=> $1 <=-"
}

rsync -a ~/workspace/dev/mjj-config/fontconfig/ ~/.config/fontconfig/
log "fontconfig 配置同步完成"

fc-cache -f
log "font 字体缓存已刷新"

rsync -a ~/workspace/dev/mjj-config/gitconfig/.gitconfig ~/
log "gitconfig 配置同步完成"

chmod 600 ~/.gitconfig
log "gitconfig 文件权限已设置"

rsync -a ~/workspace/dev/mjj-config/ssh/config ~/.ssh/
log "ssh config 配置同步完成"

chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
log "ssh 文件权限已设置"
