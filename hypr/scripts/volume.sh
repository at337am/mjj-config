#!/usr/bin/env bash

# --- 配置 ---
# 音量调整步长 (例如, 5 就是 5%)
STEP=5
# 音量上限 (例如, 100 就是 100%)
MAX_VOLUME=100
# 使用 @DEFAULT_AUDIO_SINK@ 会自动选择当前默认的输出设备
SINK="@DEFAULT_AUDIO_SINK@"

# --- 脚本主逻辑 ---

# 函数：获取当前音量（0-100之间的整数）
get_volume() {
    # wpctl get-volume 输出 "Volume: 0.80" 这样的格式
    # 我们用 awk 提取数字部分并乘以100，然后用 printf 转为整数
    wpctl get-volume $SINK | awk '{print $2 * 100}' | xargs printf "%.0f"
}

# 函数：检查是否静音
is_muted() {
    # 如果输出中包含 [MUTED]，则返回0 (表示true)
    wpctl get-volume $SINK | grep -q "[MUTED]"
}

# 根据传入的第一个参数（up, down, mute）执行不同操作
case "$1" in
    up)
        # 增加音量，并设置上限
        current=$(get_volume)
        if [ "$current" -lt "$MAX_VOLUME" ]; then
            wpctl set-volume $SINK "${STEP}%+"
        else
            # 如果已经达到或超过上限，就直接设置为上限值
            wpctl set-volume $SINK "${MAX_VOLUME}%"
        fi
        ;;
    down)
        # 降低音量
        wpctl set-volume $SINK "${STEP}%-"
        ;;
    mute)
        # 切换静音
        wpctl set-mute $SINK toggle

        # 检查切换后的状态并发送通知
        if is_muted; then
            notify-send "音量已静音" -i audio-volume-muted -h string:x-dunst-stack-tag:volume_notif
        else
            # 获取当前音量用于显示
            volume=$(get_volume)
            notify-send "音量已取消静音" "当前音量: ${volume}%" -i audio-volume-high -h string:x-dunst-stack-tag:volume_notif
        fi
        ;;
esac
