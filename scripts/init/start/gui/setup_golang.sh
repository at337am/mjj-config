#!/usr/bin/env bash

set -euo pipefail

log() {
    printf '\n-=> %s <=-\n' "$1"
}

log "开始配置 Go 环境"

go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct

log "Go 环境配置完成"

log "准备安装 skit"

if [ ! -d "$HOME/workspace/dev/skit" ]; then
    log "错误: skit 目录不存在!"
    exit 1
fi

(
    cd "$HOME/workspace/dev/skit" && \
    just install-all
)
