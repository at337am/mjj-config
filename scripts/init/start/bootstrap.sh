#!/usr/bin/env bash

# 设置严格模式，任何错误都会导致脚本退出
set -euo pipefail

log() {
    printf '\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n-=> %s\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n\n' "$1"
}

log "检查源配置目录是否存在..."
if [ ! -d "$HOME/workspace/dev/mjj-config" ]; then
    log "错误: mjj-config 目录不存在!"
    exit 1
fi
log "源配置目录检查通过, 开始执行..."

SCRIPTS=(
    "01_dnf_install.sh"
    "02_rsync_zsh.sh"
    "03_rsync_config.sh"
    "04_symlink_config.sh"
    "05_flatpak_install.sh"
    "06_setup_flatpak_app_permissions.sh"
)

for script in "${SCRIPTS[@]}"; do
    if [[ ! -f "$script" ]]; then
        echo "错误: 脚本 '$script' 不存在, 退出执行"
        exit 1
    fi

    log "开始执行 $script..."

    ./"$script"

    log "执行完毕 $script"
done
