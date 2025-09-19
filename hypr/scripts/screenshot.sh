#!/usr/bin/env sh

output_dir="$HOME/Pictures/Screenshots"
mkdir -p "$output_dir"

file_path="$output_dir/$(date +'%Y-%m-%d_%H-%M-%S').png"

notify() {
    notify-send -a "screenshot" "Screenshot" "$1"
}

case "$1" in
    "area-save")
        # 区域截图并保存
        geometry=$(slurp)
        if [ -n "$geometry" ]; then
            grim -g "$geometry" "$file_path"
            notify "区域截图已保存到 $file_path"
        else
            notify "截图已取消"
        fi
        ;;
    "full-save")
        # 全屏截图并保存
        grim "$file_path"
        notify "全屏截图已保存到 $file_path"
        ;;
    "area-copy")
        # 区域截图并复制到剪贴板
        geometry=$(slurp)
        if [ -n "$geometry" ]; then
            grim -g "$geometry" - | wl-copy -t image/png
            notify "区域截图已复制到剪贴板"
        else
            notify "截图已取消"
        fi
        ;;
    "full-copy")
        # 全屏截图并复制到剪贴板
        grim - | wl-copy -t image/png
        notify "全屏截图已复制到剪贴板"
        ;;
    *)
        echo "用法: $0 {area-save|full-save|area-copy|full-copy}"
        exit 1
        ;;
esac
