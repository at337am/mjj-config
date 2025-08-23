#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
    printf "参数错误\n" >&2
    printf "用法: %s <视频文件>\n" "ffmpeg-extract-audio.sh" >&2
    exit 1
fi

VID_PATH="$1"

# 检查输入文件是否存在
if [ ! -f "$VID_PATH" ]; then
    printf "Error: 视频文件不存在: %s\n" "$VID_PATH" >&2
    exit 1
fi

# 使用 ffprobe 获取音频编码格式
audio_codec=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$VID_PATH")

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

# 构建输出文件名
dirname=$(dirname "$VID_PATH")
basename=$(basename "$VID_PATH")
filename="${basename%.*}"

output_path="${dirname}/${filename}_audio.${ext}"

# --- 开始执行 ---

# 无损提取音频
ffmpeg -hide_banner -loglevel error \
    -i "$VID_PATH" \
    -vn \
    -c:a copy \
    -y "$output_path"

if [ $? -eq 0 ]; then
    printf "OK -> %s\n" "$output_path"
else
    printf "ERR -> %s\n" "$output_path" >&2
    exit 1
fi
