#!/usr/bin/env bash

# obsidian config 备份流程:
# 先恢复跟踪 -> 使用脚本重置 -> 改配置 -> git 提交 -> 运行此备份脚本 -> 最后忽略跟踪

mkdir -p /data/bak/restore/old/

bak_path="/data/bak/restore/obsidian_config.tar.gz"

old_bak_path="/data/bak/restore/old/obsidian_config_$(date "+%s").tar.gz"

if [ -f "$bak_path" ]; then
    mv -v "$bak_path" "$old_bak_path"
fi

tar -zcvf "$bak_path" -C ~/Documents/notes/ .obsidian

printf "✅ obsidian 备份完成\n"
