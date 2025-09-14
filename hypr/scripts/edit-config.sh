#!/usr/bin/env bash

declare -A configs
configs["hypr"]="$HOME/.config/hypr"
configs["rofi"]="$HOME/.config/rofi"
configs["kitty"]="$HOME/.config/kitty"
configs["rime"]="$HOME/.local/share/fcitx5/rime"
configs["waybar"]="$HOME/.config/waybar"

config_choice=$(printf "%s\n" "${!configs[@]}" | rofi -dmenu -i -p "Edit File")

# 如果按 Esc 退出，则脚本结束
if [[ -z "$config_choice" ]]; then
    exit 0
fi

# 获取所选文件对应的真实路径
file_path=${configs[$config_choice]}

code "$file_path" &

# kitty -e nvim "$file_path"
