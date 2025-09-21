#!/usr/bin/env bash

# 设置严格模式，任何错误都会导致脚本退出
set -euo pipefail

log() {
    echo "-=> $1 <=-"
}

sudo systemctl stop firewalld
sudo systemctl disable firewalld
log "防火墙已关闭"

sudo timedatectl set-local-rtc '0'
log "已将硬件时钟设置为 UTC"

echo 'Defaults    timestamp_timeout=60' | sudo tee -a /etc/sudoers
echo 'Defaults    !tty_tickets' | sudo tee -a /etc/sudoers
log "已将 sudo 过期时间设置为 60 分钟"

echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/sbin/shutdown" | sudo tee -a /etc/sudoers
log "已设置免密关机"

mkdir -p ~/.config
mkdir -p ~/.local/share

sudo mkdir -p /workspace/dev /workspace/tmp
sudo chown -R $(whoami):$(id -gn) /workspace
ln -s /workspace ~/workspace

sudo mkdir -p /data/bak/restore /data/hello /data/misc/tgboom
sudo chown -R $(whoami):$(id -gn) /data

sudo mkdir -p /opt/soft /opt/venvs
sudo chown -R $(whoami):$(id -gn) /opt/soft /opt/venvs

log "已创建相关目录结构"
