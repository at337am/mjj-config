#!/usr/bin/env bash

bak_path="/data/bak/restore/obsidian_config.tar.gz"

if [[ ! -f "$bak_path" ]]; then
    printf "Error: 文件备份不存在: %s\n" "$bak_path" >&2
    exit 1
fi

command rm -rfv ~/Documents/notes/.obsidian

tar -zxvf "$bak_path" -C ~/Documents/notes/

printf "✅ obsidian 已恢复至原配置\n"
