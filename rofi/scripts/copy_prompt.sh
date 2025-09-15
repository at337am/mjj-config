#!/usr/bin/env bash

if pgrep -x rofi > /dev/null; then
    pkill -x rofi
    exit 0
fi

notes_path="$HOME/Documents/notes/prompts"

rofi_prompt="选择一个 Prompt"

if [ ! -d "$notes_path" ]; then
    rofi -e "错误: 目录未找到: $notes_path"
    exit 1
fi

selected_file=$( (cd "$notes_path" && ls -1) | rofi -dmenu -i -p "$rofi_prompt")

if [ -z "$selected_file" ]; then
    exit 0
fi

full_path="$notes_path/$selected_file"

if [ -f "$full_path" ]; then
    wl-copy < "$full_path"
    notify-send "rofi" "提示词已拷贝! '$selected_file'"
else
    notify-send "rofi" "提示词拷贝失败! '$selected_file' 不是一个有效的文件"
    exit 1
fi
