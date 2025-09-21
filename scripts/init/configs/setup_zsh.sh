#!/usr/bin/env bash

# 设置严格模式，任何错误都会导致脚本退出
set -euo pipefail

log() {
    echo "-=> $1 <=-"
}

log "开始清理 zsh 旧配置..."
command rm -rf ~/.p10k.zsh
command rm -rf ~/.zshrc
command rm -rf ~/.zsh_history
command rm -rf ~/.zcompdump
command rm -rf ~/.lain
command rm -rf ~/.cache/p10k*
log "zsh 旧配置清理完成"

log "开始同步 zsh 配置..."
rsync -a ~/workspace/dev/mjj-config/zsh/ ~/
log "zsh 配置同步完成"

log "开始解压 zsh p10k 主题..."
(
  # 在子 shell 中执行，这样 cd 不会影响脚本的当前目录
  cd ~/.lain/themes && \
  tar -zxf powerlevel10k.tar.gz && \
  command rm -f powerlevel10k.tar.gz
)
log "zsh p10k 主题解压完成"

log "开始设置 zsh 文件权限..."
chmod 600 ~/.zshrc
chmod 600 ~/.zprofile
chmod 600 ~/.p10k.zsh
log "zsh 文件权限已设置"

log "开始设置 aliases.zsh 链接..."
# 先删除，防止 ln 报错（如果链接已存在）
command rm -f ~/.lain/lib/aliases.zsh
# 再创建
ln -s ~/workspace/dev/mjj-config/zsh/.lain/lib/aliases.zsh ~/.lain/lib/aliases.zsh
log "zsh aliases.zsh 链接设置完成"

log "开始设置 zsh 为默认 shell..."
chsh -s /usr/bin/zsh
log "zsh 已设置为默认 shell"
