#!/usr/bin/env bash

# 设置严格模式，任何错误都会导致脚本退出
set -euo pipefail

echo "检查源配置目录是否存在..."
if [ ! -d "$HOME/workspace/dev/mjj-config" ]; then
    echo "错误: mjj-config 目录不存在!"
    exit 1
fi
echo "源配置目录检查通过, 开始执行..."

log() {
    echo "========================================="
    echo "=> $1"
    echo "========================================="
}

log "第一步: 执行基础设置"
./start/setup_basic.sh

log "第二步: 安装 DNF 软件包"
./start/dnf_install.sh

log "第三步: 同步 Zsh 配置"
./start/rsync_zsh.sh

log "第四步: 同步通用配置"
./start/rsync_config.sh

log "第五步: 创建符号链接"
./start/symlink_config.sh

log "所有脚本执行完毕!"
