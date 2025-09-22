#!/usr/bin/env bash

set -euo pipefail

log() {
    printf '\n-=> %s <=-\n' "$1"
}

log "清理 zsh 旧配置..."
command rm -rf ~/.p10k.zsh
command rm -rf ~/.zshrc
command rm -rf ~/.zsh_history
command rm -rf ~/.zcompdump
command rm -rf ~/.lain
command rm -rf ~/.cache/p10k*

log "同步 zsh 配置..."
rsync -a ~/workspace/dev/mjj-config/zsh/ ~/

log "解压 zsh p10k 主题..."
(
  cd ~/.lain/themes && \
  tar -zxf powerlevel10k.tar.gz && \
  command rm -rf powerlevel10k.tar.gz
)

log "设置 zsh 文件权限..."
chmod 600 ~/.zshrc
chmod 600 ~/.zprofile
chmod 600 ~/.p10k.zsh

log "创建符号链接 aliases.zsh ..."
command rm -rf ~/.lain/lib/aliases.zsh
ln -s ~/workspace/dev/mjj-config/zsh/.lain/lib/aliases.zsh ~/.lain/lib/aliases.zsh

log "设置 zsh 为默认 shell ..."
chsh -s /usr/bin/zsh
