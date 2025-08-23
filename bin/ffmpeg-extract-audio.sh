#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
    printf "参数错误\n" >&2
    printf "用法: %s <视频文件>\n" "$0"
    exit 1
fi

VIDEO_PATH="$1"

# 检查输入文件是否存在
if [ ! -f "$VIDEO_PATH" ]; then
    printf "Error: 视频文件不存在: %s\n" "$VIDEO_PATH" >&2
    exit 1
fi

# 使用 ffprobe 获取音频编码格式
audio_codec=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$VIDEO_PATH")

# 提示音频编码信息
printf "音频编码: %s\n" "$audio_codec"

# 根据编码格式选择输出后缀
case "$audio_codec" in
    aac)
        ext="m4a"
        ;;
    mp3)
        ext="mp3"
        ;;
    ac3)
        ext="ac3"
        ;;
    opus)
        ext="opus"
        ;;
    pcm_s16le|pcm_s24le|pcm_s32le)
        ext="wav"
        ;;
    *)
        echo "Error: 不支持的音频编码: $audio_codec" >&2
        exit 1
        ;;
esac

# 获取视频所在目录和原文件名
dirname=$(dirname "$VIDEO_PATH")
basename=$(basename "$VIDEO_PATH")
filename="${basename%.*}"

# 构建输出文件路径：原文件名_音频.后缀
output_path="$dirname/${filename}_audio.$ext"

# --- 开始执行 ---

# 无损提取音频
ffmpeg -hide_banner -loglevel error \
    -i "$VIDEO_PATH" \
    -vn \
    -c:a copy \
    -y "$output_path"

echo

if [ $? -eq 0 ]; then
    printf "OK -> %s\n" "$output_path"
else
    printf "ERR -> %s\n" "$output_path" >&2
    exit 1
fi
