#!/usr/bin/env bash

# 定义文字高度占图片总高度的百分比
readonly PERCENTAGE=0.03

# 检查是否提供了图片路径参数
if [ "$#" -ne 1 ]; then
    printf "Error: 请提供一个图片路径作为参数\n"
    exit 1
fi

# 图片路径
input_image="$1"

# 使用 magick identify 获取图片的高度
image_height=$(magick identify -format "%h" "$input_image")

# --- 定义参数 ---

# 字体颜色
font_color="white"

# 字体样式
font_style="IBM-Plex-Sans-Italic"

# 字体大小
font_size=$(echo "$image_height * $PERCENTAGE / 1" | bc)

# 底部边距
x_offset=$(echo "$font_size * 0.5 / 1" | bc)
y_offset=$(echo "$font_size * 0.25 / 1" | bc)

# 指定输出路径
mkdir -p output_magick/
output_file="output_magick/$(basename "${input_image%.*}").png"

# --- 开始执行 ---

# 输出提示信息
printf "图片高度: %s px\n" "$image_height"
printf "字体大小: %s pt\n" "$font_size"
printf "水平偏移: %s px, 垂直偏移: %s px\n" "$x_offset" "$y_offset"

# 执行 magick 命令
magick "$input_image" \
    -gravity SouthEast \
    -font "$font_style" \
    -pointsize "$font_size" \
    -fill "$font_color" \
    -annotate +$x_offset+$y_offset "Shot on Pixel 3 · Aug 19 PM" \
    "$output_file"

# 最后输出完成信息
printf "已完成 -> %s\n" "$output_file"
