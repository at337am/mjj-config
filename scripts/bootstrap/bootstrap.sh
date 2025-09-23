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
    "nekoray.tar.gz"
    # todo, 这里只是为了测试暂时不需要 ssh
    # "ssh.tar"
)

files_dir="$HOME/pkgs"

for file in "${files[@]}"; do
    if [[ ! -f "$files_dir/$file" ]]; then
        log "Error: 所需文件不存在: $files_dir/$file"
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

tar -zxf "$files_dir/fonts.tar.gz" -C ~/.local/share/
log "fonts 已到位"

tar -zxf "$files_dir/nekoray.tar.gz" -C /opt/soft/
log "nekoray 已到位"

# todo, 这里只是为了测试暂时不需要 ssh
# command rm -rf ~/.ssh
# tar -zxf "$files_dir/ssh.tar" -C ~/
# log "ssh 已到位"

log "解压完毕, 各文件已到位"
# ------------- 解压文件 END -------------- #



# ------------- 执行脚本 START -------------- #
SCRIPT_DIR="tasks"

if [[ ! -d "$SCRIPT_DIR" ]]; then
    log "Error: 目录 '$SCRIPT_DIR' 不存在"
    exit 1
fi

find "$SCRIPT_DIR" -maxdepth 1 -name "*.sh" | sort -V | while read -r script; do
    if [[ ! -x "$script" ]]; then
        log "Error: 脚本 '$script' 没有执行权限"
        exit 1
    fi

    log "开始执行脚本: $script"

    "$script"

    # 检查上一个命令（也就是执行的脚本）的退出码
    # 如果退出码不为 0，表示执行失败
    exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        log "Error: 脚本 '$script' 执行失败, 退出码: $exit_code"
        exit 1
    fi

    log "脚本执行完毕: $script"
done
# ------------- 执行脚本 END -------------- #



# 最后:
log "设置 zsh 为默认 shell..."
chsh -s /usr/bin/zsh
