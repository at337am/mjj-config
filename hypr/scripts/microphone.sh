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
    notify-send -a "microphone" "麦克风已静音" -h string:x-dunst-stack-tag:microphone_notif
else
    notify-send -a "microphone" "麦克风已开启" -h string:x-dunst-stack-tag:microphone_notif
fi