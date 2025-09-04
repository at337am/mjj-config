#!/usr/bin/env bash

usage() {
    printf "用法: %s [-e jpg|png] <视频路径>\n" "ffmpeg-extract-frames.sh" >&2
    exit 1
}

ext="jpg"

# 使用 getopts 时, 选项必须以 - 开头
# * 用来处理 未知或非法的选项, 而不是匹配所有普通参数
# 没有 - 的参数不会被 getopts 当作选项处理, 它们在 $@ 中保留
while getopts ":e:" opt; do
    case $opt in
        e) ext="$OPTARG" ;;
        *) usage ;;
    esac
done

# getopts 会解析形如 -e jpg 这样的选项, 并把它们放到内置变量里
# 解析完以后, $OPTIND 会指向 下一个未处理的位置参数
# shift $((OPTIND - 1)) 的作用就是把这些已经处理过的选项"移走", 只留下真正的 位置参数
shift $((OPTIND - 1))

video_path="$1"

if [[ "$#" -ne 1 ]]; then
    printf "参数错误\n" >&2
    usage
fi

video_base=$(basename "$video_path")

# 根据扩展名选择输出目录后缀和 ffmpeg 参数
if [[ "$ext" == "jpg" ]]; then
    output_dir="${video_base%.*}_jpg_frames"
    ffmpeg_opts=(-q:v 6)
elif [[ "$ext" == "png" ]]; then
    output_dir="${video_base%.*}_png_frames"
    ffmpeg_opts=(-compression_level 0)
else
    printf "不支持的图像格式: %s\n" "$ext" >&2
    usage
fi

mkdir -p "$output_dir"
output_name="$output_dir/output_%04d.$ext"

ffmpeg -i "$video_path" \
    -vsync 0 \
    "${ffmpeg_opts[@]}" \
    "$output_name"

printf "已提取至 -> %s\n" "$output_dir"
