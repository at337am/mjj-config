#!/usr/bin/env bash

rsync -a ~/workspace/dev/mjj-config/fontconfig/ ~/.config/fontconfig/ && \
fc-cache -fv
echo "fontconfig 配置同步完成"

rsync -a ~/workspace/dev/mjj-config/gitconfig/.gitconfig ~/ && \
chmod 600 ~/.gitconfig
echo ".gitconfig 配置同步完成"

rsync -a ~/workspace/dev/mjj-config/ssh/config ~/.ssh/ && \
chmod 700 ~/.ssh && \
chmod 600 ~/.ssh/config && \
chmod 600 ~/.ssh/id_rsa && \
chmod 644 ~/.ssh/id_rsa.pub
echo ".ssh/config 配置同步完成"
