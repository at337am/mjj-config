#!/usr/bin/env bash

bak_path="/data/bak/restore/nekoray.tar.gz"
old_bak_path="/data/bak/restore/old/nekoray_$(date "+%s").tar.gz"

restore() {
	if [[ ! -f "$bak_path" ]]; then
		printf "Error: 文件备份不存在: %s\n" "$bak_path" >&2
		exit 1
	fi

	pkill -15 nekoray || printf "nekoray 未运行，跳过终止步骤\n"

	sleep 2

	command rm -rfv /opt/soft/nekoray

	tar -zxvf "$bak_path" -C /opt/soft/

	printf "✅ nekoray 已恢复至原配置\n"
}

bak() {
	mkdir -p /data/bak/restore/old/

	pkill -15 nekoray || printf "nekoray 未运行，跳过终止步骤\n"

	sleep 2

	if [[ -f "$bak_path" ]]; then
		mv -v "$bak_path" "$old_bak_path"
	fi

	tar -zcvf "$bak_path" -C /opt/soft/ nekoray

	printf "✅ nekoray 备份完成\n"
}

if [[ "$#" -eq 0 ]]; then
    restore
elif [[ "$#" -eq 1 && "$1" == "bak" ]]; then
    bak
else
    printf "参数错误\n" >&2
    printf "用法: %s [bak]\n" "restore_nekoray.sh" >&2
    exit 1
fi
