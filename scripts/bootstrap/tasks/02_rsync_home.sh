#!/usr/bin/env bash

set -euo pipefail

log() {
    printf '\n-=> %s <=-\n' "$1"
}

# 检查是否需要跳过
if [[ -e "$HOME/.lain/themes/powerlevel10k" ]]; then
    log "此脚本不再重复执行, 跳过"
    exit 0
fi

command rm -rf ~/.p10k.zsh
command rm -rf ~/.zshrc
command rm -rf ~/.zsh_history
command rm -rf ~/.zcompdump
command rm -rf ~/.zprofile
command rm -rf ~/.lain
command rm -rf ~/.cache/p10k*

# -------------------------------- #
log "同步所有配置..."

rsync -a ../../home/ ~/

log "所有配置同步完成"
# -------------------------------- #



# -------------------------------- #
log "设置 zsh 文件权限..."
chmod 600 ~/.zshrc
chmod 600 ~/.zprofile
chmod 600 ~/.p10k.zsh

log "设置 gitconfig 文件权限..."
chmod 600 ~/.gitconfig

log "设置 ssh 文件权限..."
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
# todo, 这里只是为了测试暂时不需要 ssh
# chmod 600 ~/.ssh/id_rsa
# chmod 644 ~/.ssh/id_rsa.pub

log "文件权限都已设置完成"
# -------------------------------- #



# -------------------------------- #
log "解压 p10k 主题到 ~/.lain/themes..."

tar -zxf ~/.lain/themes/powerlevel10k.tar.gz -C ~/.lain/themes

log "p10k 主题解压完成"
# -------------------------------- #



# -------------------------------- #
log "刷新 font 字体缓存..."

fc-cache -f

log "字体缓存已刷新"
# -------------------------------- #



# -------------------------------- #
log "清理多余文件..."

command rm -rfv ~/.lain/themes/powerlevel10k.tar.gz
command rm -rfv ~/.local/share/fcitx5/rime/weasel.yaml

log "多余文件清理完成"
# -------------------------------- #
