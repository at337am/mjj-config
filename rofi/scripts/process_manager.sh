#!/usr/bin/env bash

if pgrep -x rofi > /dev/null; then
    pkill -x rofi
    exit 0
fi

# 步骤 1: 获取进程列表并让用户选择
# 使用 ps 命令获取进程信息: PID, 用户, CPU占用, 内存占用, 命令名
# -eo: 自定义输出格式
# --sort=-%cpu: 按 CPU 使用率降序排序
# sed '1d': 删除 ps 命令输出的第一行标题
# rofi -dmenu: 以 dmenu 模式启动 Rofi
# -i: 不区分大小写
# -p: 设置提示符
# -l 20: 默认显示 20 行
selected_process=$(ps -u $USER -o pid,user,%cpu,%mem,comm --sort=-%cpu | sed '1d' | rofi -dmenu -i -p "Processes" -l 8)

# 如果用户没有选择任何东西 (按了 Esc), 就退出脚本
if [ -z "$selected_process" ]; then
    exit 0
fi

# 步骤 2: 从用户选择的行中提取 PID 和命令名
# awk '{print $1}' 获取第一列 (PID)
pid=$(echo "$selected_process" | awk '{print $1}')
# awk '{print $5}' 获取第五列 (命令名)
comm=$(echo "$selected_process" | awk '{print $5}')

# 步骤 3: 创建操作菜单并让用户选择
# 定义操作选项, 使用 Nerd Font 图标增强视觉效果
kill_term=" Terminate (SIGTERM)"
kill_kill=" Kill (SIGKILL)"
details=" View Details"

# 组合选项
options="$details\n$kill_term\n$kill_kill"

# 显示第二个 Rofi 菜单，提示符中包含进程名和 PID
chosen_action=$(echo -e "$options" | rofi -dmenu -p "Action for $comm (PID: $pid)")

# 步骤 4: 根据用户的选择执行相应的操作
case "$chosen_action" in
    "$kill_term")
        # 发送 SIGTERM (15) 信号，允许程序优雅地关闭
        kill -15 "$pid"
        notify-send "Rofi Process Manager" "Sent SIGTERM to $comm (PID: $pid)"
        ;;
    "$kill_kill")
        # 发送 SIGKILL (9) 信号，强制杀死进程
        kill -9 "$pid"
        notify-send "Rofi Process Manager" "Sent SIGKILL to $comm (PID: $pid)"
        ;;
    "$details")
        # 显示进程
        kitty -e htop -p "$pid"
        ;;
esac

exit 0