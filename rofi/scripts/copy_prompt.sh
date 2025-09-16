#!/usr/bin/env bash

if pgrep -x rofi > /dev/null; then
    pkill -x rofi
    exit 0
fi

notes_path="$HOME/Documents/notes/prompts"

rofi_prompt="Prompts"

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
    notify-send -a "prompts" \
                "Copied" \
                -h string:x-dunst-stack-tag:prompts_notif
else
    notify-send -a "prompts" \
                "Copy Failed" \
                -h string:x-dunst-stack-tag:prompts_notif
    exit 1
fi
