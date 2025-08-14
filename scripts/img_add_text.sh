#!/usr/bin/env bash

# 0.05 代表文字高度是图片总高度的 5%
# 0.1  代表文字高度是图片总高度的 10%
readonly PERCENTAGE=0.05

# 1. 检查是否提供了图片路径参数
if [ "$#" -ne 1 ]; then
    printf "Error: 请提供一个图片路径作为参数\n"
    exit 1
fi

# 2. 从参数中获取输入图片路径
input_image="$1"

# 3. 使用 magick identify 获取图片的高度
image_height=$(magick identify -format "%h" "$input_image")

# 4. 计算字体大小 (pointsize)
point_size=$(echo "scale=0; $image_height * $PERCENTAGE / 1" | bc)

# 5. 指定输出路径
mkdir -p output_magick/
output_file="output_magick/$(basename "$input_image")"

# 6. 执行 magick 命令
magick "$input_image" \
    -gravity SouthEast \
    -font "Adwaita-Sans-Italic" \
    -pointsize "$point_size" \
    -fill black \
    -annotate +10+10 "2025 My dear IU" \
    "$output_file"

# 7. 最后输出完成信息和文件名
printf "已完成 -> %s\n" "$output_file"
