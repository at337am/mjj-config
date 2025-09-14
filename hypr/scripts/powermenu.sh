#!/usr/bin/env bash

if pgrep -x rofi > /dev/null
then
    pkill -x rofi
else
    # 定义选项和图标
    shutdown=" Shutdown"
    reboot=" Reboot"
    lock=" Lock"
    logout=" Logout"

    # 使用 Rofi 显示菜单
    # -dmenu: 从标准输入读取
    # -p: 设置提示符
    # -i: 不区分大小写
    # -config: 指定一个自定义主题（可选）
    selected_option=$(echo -e "$shutdown\n$reboot\n$lock\n$logout" | rofi -dmenu -p "Power" -i)

    # 根据选择执行命令
    case "$selected_option" in
        "$shutdown")
            systemctl poweroff
            ;;
        "$reboot")
            systemctl reboot
            ;;
        "$lock")
            hyprlock
            ;;
        "$logout")
            # Hyprland 的退出命令
            hyprctl dispatch exit
            ;;
    esac
fi
