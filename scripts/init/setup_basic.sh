#!/usr/bin/env bash

set -euo pipefail

log() {
    printf '\n-=> %s <=-\n' "$1"
}

# -------------------------------- #

files=(
    "fonts.tar.gz"
    "mjj-config.tar.gz"
    "nekoay.tar.gz"
    "ssh.tar"
)

files_dir="$HOME/pkgs"

for file in "${files[@]}"; do
    if [[ ! -f "$data_dir/$file" ]]; then
        log "Error: 准备文件不存在: $data_dir/$file"
        exit 1
    fi
done

# -------------------------------- #

log "关闭防火墙..."
sudo systemctl stop firewalld
sudo systemctl disable firewalld

log "设置硬件时钟为 UTC..."
sudo timedatectl set-local-rtc '0'

log "设置 sudo 过期时间为 60 分钟..."
echo 'Defaults    timestamp_timeout=60' | sudo tee -a /etc/sudoers
echo 'Defaults    !tty_tickets' | sudo tee -a /etc/sudoers

log "设置免密关机..."
echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/sbin/shutdown" | sudo tee -a /etc/sudoers

log "创建相关目录结构..."

mkdir -p ~/.config
mkdir -p ~/.local/share

sudo mkdir -p /workspace/dev /workspace/tmp
sudo chown -R $(whoami):$(id -gn) /workspace
ln -s /workspace ~/workspace

sudo mkdir -p /data/bak/restore /data/hello /data/misc/tgboom
sudo chown -R $(whoami):$(id -gn) /data

sudo mkdir -p /opt/soft /opt/venvs
sudo chown -R $(whoami):$(id -gn) /opt/soft /opt/venvs

# -------------------------------- #

log "解压准备文件到指定目录"

command rm -rf "$HOME/.local/share/fonts"
tar -zxf "$files_dir/fonts.tar.gz" -C ~/.local/share

tar -zxf "$files_dir/mjj-config.tar.gz" -C ~/workspace/dev
