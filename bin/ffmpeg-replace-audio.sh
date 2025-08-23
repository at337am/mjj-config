#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
    printf "参数错误\n" >&2
    printf "用法: %s <视频文件> <音频文件>\n" "ffmpeg-replace-audio.sh"
    exit 1
fi

VID_PATH="$1"
AUD_PATH="$2"

# 检查输入文件是否存在
if [ ! -f "$VID_PATH" ]; then
    printf "Error: 视频文件不存在: %s\n" "$VID_PATH" >&2
    exit 1
fi
if [ ! -f "$AUD_PATH" ]; then
    printf "Error: 音频文件不存在: %s\n" "$AUD_PATH" >&2
    exit 1
fi

# 构建输出文件名
dirname=$(dirname "$VID_PATH")
basename=$(basename "$VID_PATH")
filename="${basename%.*}"
ext="${basename##*.}"

output_path="${dirname}/${filename}_repaudio.${ext}"

# --- 开始执行 ---

# -c:v copy: 视频流直接复制，不重新编码
# -c:a copy: 音频流直接复制，不重新编码
# -map 0:v: 映射第一个输入(视频)的视频流
# -map 1:a: 映射第二个输入(音频)的音频流
# -shortest: 当最短的输入流结束时，完成编码
ffmpeg -hide_banner -loglevel error \
    -i "$VID_PATH" \
    -i "$AUD_PATH" \
    -c:v copy \
    -c:a copy \
    -map 0:v \
    -map 1:a \
    -shortest \
    -y "$output_path"

if [ $? -eq 0 ]; then
    printf "OK -> %s\n" "$output_path"
else
    printf "ERR -> %s\n" "$output_path" >&2
    exit 1
fi
