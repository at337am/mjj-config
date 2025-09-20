#!/usr/bin/env bash

rsync -a ~/workspace/dev/mjj-config/fontconfig/ ~/.config/fontconfig/
echo "-=> fontconfig 配置同步完成"

fc-cache -f
echo "-=> font 字体缓存已刷新"

rsync -a ~/workspace/dev/mjj-config/gitconfig/.gitconfig ~/
echo "-=> gitconfig 配置同步完成"

chmod 600 ~/.gitconfig
echo "-=> gitconfig 文件权限已设置"

rsync -a ~/workspace/dev/mjj-config/ssh/config ~/.ssh/
echo "-=> ssh config 配置同步完成"

chmod 700 ~/.ssh && \
chmod 600 ~/.ssh/config && \
chmod 600 ~/.ssh/id_rsa && \
chmod 644 ~/.ssh/id_rsa.pub
echo "-=> ssh 文件权限已设置"
