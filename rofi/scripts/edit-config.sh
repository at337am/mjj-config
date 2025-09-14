#!/usr/bin/env bash

if pgrep -x rofi > /dev/null; then
    pkill -x rofi
    exit 0
fi

declare -A configs
configs["hypr"]="$HOME/.config/hypr"
configs["rofi"]="$HOME/.config/rofi"
configs["waybar"]="$HOME/.config/waybar"
configs["kitty"]="$HOME/.config/kitty"
configs["rime"]="$HOME/.local/share/fcitx5/rime"

config_choice=$(printf "%s\n" "${!configs[@]}" | rofi -dmenu -i -p "Edit Config")

# 如果按 Esc 退出，则脚本结束
if [[ -z "$config_choice" ]]; then
    exit 0
fi

# 获取所选文件对应的真实路径
file_path=${configs[$config_choice]}

command code "$file_path" --ozone-platform-hint=auto > /dev/null 2>&1 &

# kitty -e nvim "$file_path"
