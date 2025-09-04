#!/usr/bin/env bash

bak_path="/data/bak/restore/nekoray.tar.gz"

if [[ ! -f "$bak_path" ]]; then
    printf "Error: 文件备份不存在: %s\n" "$bak_path" >&2
    exit 1
fi

pkill -15 nekoray || printf "nekoray 未运行，跳过终止步骤\n"

sleep 2

command rm -rfv /opt/soft/nekoray

tar -zxvf "$bak_path" -C /opt/soft/

printf "✅ nekoray 已恢复至原配置\n"
