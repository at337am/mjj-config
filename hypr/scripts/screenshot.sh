#!/usr/bin/env bash

# 脚本功能: Hyprland 截图脚本
# 依赖: grim, slurp, wl-copy, swappy, notify-send

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
FILENAME="screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"
FILE_PATH="$SCREENSHOT_DIR/$FILENAME"

mkdir -p "$SCREENSHOT_DIR"

# 发送通知
notify() {
    notify-send "Screenshot" "$1" -i "camera-photo"
}

# 捕捉全屏
capture_full() {
    grim -
}

# 捕捉区域
capture_area() {
    # slurp 获取选择的区域几何信息
    local geometry
    geometry=$(slurp)
    # 如果用户按 Esc 取消了选择, slurp 会返回空, 此时脚本退出
    if [ -z "$geometry" ]; then
        exit 1
    fi
    grim -g "$geometry" -
}

# --- 主逻辑 ---

# 根据传入的第一个参数选择操作
case "$1" in
    "area-save")
        capture_area | tee "$FILE_PATH" > /dev/null
        notify "区域截图已保存到 $FILENAME"
        ;;
    "full-save")
        capture_full | tee "$FILE_PATH" > /dev/null
        notify "全屏截图已保存到 $FILENAME"
        ;;
    "area-copy")
        capture_area | wl-copy
        notify "区域截图已复制到剪贴板"
        ;;
    "full-copy")
        capture_full | wl-copy
        notify "全屏截图已复制到剪贴板"
        ;;
    "area-edit")
        capture_area | swappy -f -
        ;;
    "full-edit")
        capture_full | swappy -f -
        ;;
    *)
        echo "用法: $0 {area-save|full-save|area-copy|full-copy|area-edit|full-edit}"
        exit 1
        ;;
esac
