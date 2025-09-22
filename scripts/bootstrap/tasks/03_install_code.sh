#!/usr/bin/env bash

set -euo pipefail

log() {
    printf '\n-=> %s <=-\n' "$1"
}

log "导入 Microsoft GPG 公钥..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

log "添加 Visual Studio Code 仓库..."
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" \
    | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

log "检查软件更新..."
sudo dnf check-update

log "开始安装 Visual Studio Code..."
sudo dnf -y install code

log "Visual Studio Code 安装完成"
