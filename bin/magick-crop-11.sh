#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
    printf "参数错误\n" >&2
    printf "用法: %s <图像文件>\n" "magick-crop-11.sh" >&2
    exit 1
fi

# 图像路径
IMG_PATH="$1"

if [ ! -f "$IMG_PATH" ]; then
    printf "Error: 图像文件不存在: %s\n" "$IMG_PATH" >&2
    exit 1
fi

# 定义输出路径
dirname=$(dirname "$IMG_PATH")
filename=$(basename "${IMG_PATH%.*}")
output_path="${dirname}/${filename}_1x1.png"

# --- 开始执行 ---

# 居中裁剪一个最大正方形
magick "$IMG_PATH" \
    -gravity Center \
    -crop '%[fx:min(w,h)]x%[fx:min(w,h)]+0+0' \
    +repage \
    "$output_path"

# 最后输出完成信息
if [ $? -eq 0 ]; then
    printf "OK -> %s\n" "$output_path"
else
    printf "ERR -> %s\n" "$output_path" >&2
    exit 1
fi
