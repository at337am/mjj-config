#!/usr/bin/env bash

# 设置严格模式，任何错误都会导致脚本退出
set -euo pipefail

log "检查源配置目录是否存在..."

if [ ! -d "$HOME/workspace/dev/mjj-config" ]; then
    log "错误：源配置目录不存在！"
    echo "期望的路径：$SOURCE_DIR"
    echo "请先将您的 mjj-config 项目克隆或放置到正确位置后再运行此脚本。"
    exit 1
fi

log "源配置目录检查通过，开始执行..."

