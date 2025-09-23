#!/usr/bin/env bash

set -euo pipefail

log() {
    printf '\n-=> %s <=-\n' "$1"
}

# 检查是否需要跳过
if [[ -e "$HOME/.local/share/fcitx5/rime/en_dicts" ]]; then
    log "此脚本不再重复执行, 跳过"
    exit 0
fi

# -------------------------------- #
log "拉取 rime 输入法词库..."

wget -O ~/.local/share/fcitx5/rime/all_dicts.zip \
    https://github.com/iDvel/rime-ice/releases/latest/download/all_dicts.zip && \
unzip ~/.local/share/fcitx5/rime/all_dicts.zip -d ~/.local/share/fcitx5/rime/

log "输入法词库拉取完成"
# -------------------------------- #



# -------------------------------- #
log "清理临时文件..."

command rm -rfv ~/.local/share/fcitx5/rime/all_dicts.zip

log "临时文件清理完成"
# -------------------------------- #
