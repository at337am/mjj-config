#!/usr/bin/env bash

# --- 配置 ---
# 音量调整步长 (例如, 5 就是 5%)
STEP=5
# 音量上限 (例如, 100 就是 100%)
MAX_VOLUME=100
# 默认音频输出设备
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
        # 1. 获取当前音量
        current=$(get_volume)

        # 2. 计算目标音量
        target=$((current + STEP))

        # 3. 如果目标音量超过上限，就把它设置为上限值
        if [ "$target" -gt "$MAX_VOLUME" ]; then
            target=$MAX_VOLUME
        fi

        # 4. 最后，用计算好的目标值来设置音量（注意，这里不再用%+，而是直接设置绝对值）
        wpctl set-volume $SINK "${target}%"
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
            # 设置通知的应用程序名称为 volume
            # x-dunst-stack-tag 用来标记通知分组
            notify-send -a "volume" \
                        "Muted" \
                        -h string:x-dunst-stack-tag:volume_notif
        else
            # 获取当前音量用于显示
            volume=$(get_volume)
            notify-send -a "volume" \
                        "Unmute ($volume%)" \
                        -h string:x-dunst-stack-tag:volume_notif
        fi
        ;;
esac
