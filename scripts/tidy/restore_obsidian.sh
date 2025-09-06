#!/usr/bin/env bash

bak_path="/data/bak/restore/obsidian_config.tar.gz"
old_bak_path="/data/bak/restore/old/obsidian_config_$(date "+%s").tar.gz"

restore() {
	if [[ ! -f "$bak_path" ]]; then
		printf "Error: 文件备份不存在: %s\n" "$bak_path" >&2
		exit 1
	fi

	command rm -rfv ~/Documents/notes/.obsidian

	tar -zxvf "$bak_path" -C ~/Documents/notes/

	printf "✅ obsidian 已恢复至原配置\n"
}

# obsidian config 备份流程:
# 先恢复跟踪 -> 使用脚本重置 -> 改配置 -> git 提交 -> 运行此备份脚本 -> 最后忽略跟踪
bak() {
	mkdir -p /data/bak/restore/old/

	if [[ -f "$bak_path" ]]; then
		mv -v "$bak_path" "$old_bak_path"
	fi

	tar -zcvf "$bak_path" -C ~/Documents/notes/ .obsidian

	printf "✅ obsidian 备份完成\n"
}

if [[ "$#" -eq 0 ]]; then
    restore
elif [[ "$#" -eq 1 && "$1" == "bak" ]]; then
    bak
else
    printf "参数错误\n" >&2
    printf "用法: %s [bak]\n" "restore_obsidian.sh" >&2
    exit 1
fi
