#!/usr/bin/env sh

output_dir="$HOME/Pictures/Screenshots"

mkdir -p "$output_dir"

file_path="$output_dir/$(date +'%Y-%m-%d_%H-%M-%S').png"

notify() {
    notify-send -a "screenshot" \
                -u low \
                -h string:x-dunst-stack-tag:volume_notif \
                "$1"
}

case "$1" in
    "area-save")
        geometry=$(slurp)
        if [ -n "$geometry" ]; then
            grim -g "$geometry" "$file_path"
            notify "截图已保存到本地"
        else
            notify "截图已取消"
        fi
        ;;
    "full-save")
        grim "$file_path"
        notify "截图已保存到本地"
        ;;
    "area-copy")
        geometry=$(slurp)
        if [ -n "$geometry" ]; then
            grim -g "$geometry" - | wl-copy -t image/png
            notify "截图已复制到剪贴板"
        else
            notify "截图已取消"
        fi
        ;;
    "full-copy")
        grim - | wl-copy -t image/png
        notify "截图已复制到剪贴板"
        ;;
    *)
        echo "用法: $0 {area-save|full-save|area-copy|full-copy}"
        exit 1
        ;;
esac
