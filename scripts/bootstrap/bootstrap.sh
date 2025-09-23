#!/usr/bin/env bash

# 设置严格模式，任何错误都会导致脚本退出
set -euo pipefail

log() {
    printf '\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n-=> %s\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n\n' "$1"
}

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
done
# ------------- 执行脚本 END -------------- #


# 最后:
log "设置 zsh 为默认 shell..."
chsh -s /usr/bin/zsh
