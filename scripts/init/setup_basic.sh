#!/usr/bin/env bash

# 设置严格模式，任何错误都会导致脚本退出
set -euo pipefail

log() {
    printf '\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n-=> %s\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n\n' "$1"
}

# ------------- 检查所需文件 START -------------- #
log "开始校验所需文件..."

files=(
    "fonts.tar.gz"
    "mjj-config.tar.gz"
    "nekoay.tar.gz"
    "ssh.tar"
)

files_dir="$HOME/pkgs"

for file in "${files[@]}"; do
    if [[ ! -f "$data_dir/$file" ]]; then
        log "Error: 所需文件不存在: $data_dir/$file"
        exit 1
    fi
done

log "所需文件校验完成"
# ------------- 检查所需文件 END -------------- #



# ------------- 基础设置 START -------------- #
log "开始基础设置..."

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

log "基础设置完成"
# ------------- 基础设置 END -------------- #



# ------------- 解压文件 START -------------- #
log "解压所需文件到指定位置"

command rm -rf ~/.ssh
command rm -rf ~/.local/share/fonts
command rm -rf ~/workspace/dev/mjj-config
command rm -rf /opt/soft/nekoray

tar -zxf "$files_dir/fonts.tar.gz" -C ~/.local/share/
log "fonts 已到位"

tar -zxf "$files_dir/mjj-config.tar.gz" -C ~/workspace/dev/
log "mjj-config 已到位"

tar -zxf "$files_dir/nekoay.tar.gz" -C /opt/soft/
log "nekoray 已到位"

tar -zxf "$files_dir/ssh.tar" -C ~/
log "ssh 已到位"

log "解压完毕, 各文件已到位"
# ------------- 解压文件 END -------------- #



# ------------- 执行脚本 START -------------- #
for file in "${scripts[@]}"; do
    if [[ ! -f "$file" ]]; then
        log "Error: 脚本 '$file' 不存在"
        exit 1
    fi
done

scripts=(
    "scripts/01_dnf_install.sh"
    "scripts/02_rsync_zsh.sh"
    "scripts/03_rsync_config.sh"
    "scripts/04_symlink_config.sh"
    "scripts/05_flatpak_install.sh"
    "scripts/06_setup_flatpak_perm.sh"
)

for script in "${scripts[@]}"; do
    log "开始执行脚本 $script..."

    ./"$script"

    log "执行完毕 $script"
done
# ------------- 执行脚本 END -------------- #
