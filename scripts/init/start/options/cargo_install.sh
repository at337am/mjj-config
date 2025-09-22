#!/usr/bin/env bash

set -euo pipefail

log() {
    printf '\n-=> %s <=-\n' "$1"
}

log "开始安装 cargo-cache..."

cargo install cargo-cache

log "cargo-cache 已安装"

log "开始安装 xh..."

cargo install xh

log "xh 已安装"
