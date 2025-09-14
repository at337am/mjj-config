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

# 检查切换后的新状态，并发送相应的通知
if is_mic_muted; then
    # 如果现在是静音状态，发送静音通知
    notify-send "麦克风已静音" -i microphone-sensitivity-muted -h string:x-dunst-stack-tag:mic_notif
else
    # 如果现在是开启状态，发送开启通知
    notify-send "麦克风已开启" -i microphone-sensitivity-high -h string:x-dunst-stack-tag:mic_notif
fi