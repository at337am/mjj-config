#!/usr/bin/env bash

set -euo pipefail

log() {
    printf '\n-=> %s <=-\n' "$1"
}

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
log "解压 p10k 主题到 ~/.lain/themes..."

tar -zxf ~/.lain/themes/powerlevel10k.tar.gz -C ~/.lain/themes

log "p10k 主题解压完成"
# -------------------------------- #



# -------------------------------- #
log "拉取 rime 输入法词库..."

wget -O ~/.local/share/fcitx5/rime/all_dicts.zip \
    https://github.com/iDvel/rime-ice/releases/latest/download/all_dicts.zip && \
unzip ~/.local/share/fcitx5/rime/all_dicts.zip -d ~/.local/share/fcitx5/rime/

log "输入法词库拉取完成"
# -------------------------------- #



# -------------------------------- #
log "清理临时文件..."

command rm -rfv ~/.lain/themes/powerlevel10k.tar.gz
command rm -rfv ~/.local/share/fcitx5/rime/weasel.yaml
command rm -rfv ~/.local/share/fcitx5/rime/all_dicts.zip

log "临时文件清理完成"
# -------------------------------- #



# -------------------------------- #
log "刷新 font 字体缓存..."

fc-cache -f

log "字体缓存已刷新"
# -------------------------------- #



# ------------------- 权限设置 -------------------
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
