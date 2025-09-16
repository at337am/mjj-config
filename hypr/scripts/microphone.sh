#!/usr/bin/env bash

# 默认音频输入设备
SOURCE="@DEFAULT_AUDIO_SOURCE@"

# 函数：检查麦克风是否静音
is_mic_muted() {
    # 如果 wpctl 的输出中包含 [MUTED] 字符串，则认为是静音状态
    wpctl get-volume $SOURCE | grep -q "[MUTED]"
}

# 切换麦克风的静音状态
wpctl set-mute $SOURCE toggle

if is_mic_muted; then
    notify-send -a "microphone" \
                -u low \
                -h string:x-dunst-stack-tag:volume_notif \
                "🫢  Mic Off"
else
    notify-send -a "microphone" \
                -u low \
                -h string:x-dunst-stack-tag:volume_notif \
                "😍  Mic On"
fi
