#!/usr/bin/env bash

mkdir -p /data/bak/restore/old/

bak_path="/data/bak/restore/nekoray.tar.gz"

old_bak_path="/data/bak/restore/old/nekoray_$(date "+%s").tar.gz"

pkill -15 nekoray || printf "nekoray 未运行，跳过终止步骤\n"

sleep 2

if [ -f "$bak_path" ]; then
    mv -v "$bak_path" "$old_bak_path"
fi

tar -zcvf "$bak_path" -C /opt/soft/ nekoray

printf "✅ nekoray 备份完成\n"
