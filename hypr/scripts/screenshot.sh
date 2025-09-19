#!/usr/bin/env bash

# Hyprland 截图脚本
#
# 功能:
# - 截取全屏、活动窗口、指定区域
# - 将截图保存到文件、复制到剪贴板或在 swappy 中打开编辑

# --- 配置 ---
SAVE_DIR="$HOME/Pictures/Screenshots"   # 截图保存目录
EDITOR="swappy"                       # 截图后用于编辑的程序

# --- 脚本 ---
# 确保保存目录存在
mkdir -p "$SAVE_DIR"

# 生成带时间戳的文件名
FILE_NAME="$(date +'%Y-%m-%d_%H-%M-%S.png')"
SAVE_PATH="$SAVE_DIR/$FILE_NAME"

# 获取活动窗口几何信息
get_active_window_geometry() {
    hyprctl activewindow | grep -E 'at:|size:' | grep -v 'workspace' | tr -d ' ' | cut -d ':' -f 2 | sed 's/,/x/'
}

# 显示帮助信息
show_help() {
    echo "Usage: $0 [option]"
    echo
    echo "Options:"
    echo "  full          截取全屏并保存"
    echo "  area          截取选定区域并保存"
    echo "  window        截取活动窗口并保存"
    echo "  area-copy     截取选定区域并复制到剪贴板"
    echo "  window-copy   截取活动窗口并复制到剪贴板"
    echo "  area-edit     截取选定区域并在编辑器中打开"
    echo
    exit 1
}

# 主逻辑
case "$1" in
    full)
        grim "$SAVE_PATH"
        notify-send "Screenshot" "全屏截图已保存到 $FILE_NAME"
        ;;
    area)
        grim -g "$(slurp)" "$SAVE_PATH"
        notify-send "Screenshot" "区域截图已保存到 $FILE_NAME"
        ;;
    window)
        grim -g "$(get_active_window_geometry)" "$SAVE_PATH"
        notify-send "Screenshot" "活动窗口截图已保存到 $FILE_NAME"
        ;;
    area-copy)
        grim -g "$(slurp)" - | wl-copy
        notify-send "Screenshot" "区域截图已复制到剪贴板"
        ;;
    window-copy)
        grim -g "$(get_active_window_geometry)" - | wl-copy
        notify-send "Screenshot" "活动窗口截图已复制到剪贴板"
        ;;
    area-edit)
        grim -g "$(slurp)" - | $EDITOR -f -
        ;;
    *)
        show_help
        ;;
esac

exit 0
