#!/usr/bin/env bash

command rm -rf ~/.p10k.zsh
command rm -rf ~/.zshrc
command rm -rf ~/.zsh_history
command rm -rf ~/.zcompdump
command rm -rf ~/.lain
command rm -rf ~/.cache/p10k*
echo "-=> zsh 旧配置清理完成"

rsync -a ~/workspace/dev/mjj-config/zsh/ ~/
echo "-=> zsh 配置同步完成"

(cd ~/.lain/themes && \
tar -zxf powerlevel10k.tar.gz && \
command rm -f powerlevel10k.tar.gz)
echo "-=> zsh p10k 主题解压完成"

chmod 600 ~/.zshrc
chmod 600 ~/.zprofile
chmod 600 ~/.p10k.zsh
echo "-=> zsh 文件权限已设置"

command rm -rf ~/.lain/lib/aliases.zsh
ln -s ~/workspace/dev/mjj-config/zsh/.lain/lib/aliases.zsh ~/.lain/lib/aliases.zsh
echo "-=> zsh aliases.zsh 链接设置完成"

chsh -s /usr/bin/zsh
echo "-=> zsh 已设置为默认 shell"
