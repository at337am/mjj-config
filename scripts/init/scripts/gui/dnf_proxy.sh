#!/usr/bin/env bash

set -euo pipefail

log() {
    printf '\n-=> %s <=-\n' "$1"
}

if [ ! -d "/opt/soft/nekoray" ]; then
    log "错误: nekoray 未安装"
    exit 1
fi

echo "proxy=http://127.0.0.1:2080" | sudo tee -a /etc/dnf/dnf.conf
