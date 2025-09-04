#!/usr/bin/env bash

if [[ "$#" -ne 2 ]]; then
    printf "参数错误\n" >&2
    printf "用法: %s <图像文件> <文字内容>\n" "magick-caption.sh" >&2
    exit 1
fi

# 图像路径
IMG_PATH="$1"

if [[ ! -f "$IMG_PATH" ]]; then
    printf "Error: 图像文件不存在: %s\n" "$IMG_PATH" >&2
    exit 1
fi

# 文字内容
CAPTION_TEXT="$2"

# 获取图片的高度
image_height=$(magick identify -format "%h" "$IMG_PATH")

# --- 定义参数 ---

# 字体颜色
font_color="white"

# 字体样式
font_style="Josefin-Sans-Regular"

# 字体样式参考
# IBM-Plex-Sans-Regular
# IBM-Plex-Sans-Italic
# Josefin-Sans-Regular
# Josefin-Sans-Italic
# Google-Sans-Code-Regular
# Google-Sans-Code-Italic

# 文字位置
position="SouthEast" # 右下角

# 定义文字高度占图片总高度的百分比
percentage=0.03

# 字体大小
font_size=$(echo "$image_height * $percentage / 1" | bc)

# 底部边距
x_offset=$(echo "$font_size * 0.5 / 1" | bc)
y_offset=$(echo "$font_size * 0.25 / 1" | bc)

# 定义输出路径
dirname=$(dirname "$IMG_PATH")
filename=$(basename "${IMG_PATH%.*}")
output_path="${dirname}/${filename}_caption.png"

# --- 开始执行 ---

# 输出提示信息
printf "图片高度: %s px\n" "$image_height"
printf "字体大小: %s pt\n" "$font_size"
printf "水平偏移: %s px, 垂直偏移: %s px\n" "$x_offset" "$y_offset"

# 执行 magick 命令
magick "$IMG_PATH" \
    -gravity "$position" \
    -font "$font_style" \
    -pointsize "$font_size" \
    -fill "$font_color" \
    -annotate +"$x_offset"+"$y_offset" "$CAPTION_TEXT" \
    "$output_path"

# 最后输出完成信息
if [[ "$?" -eq 0 ]]; then
    printf "OK -> %s\n" "$output_path"
else
    printf "ERR -> %s\n" "$output_path" >&2
    exit 1
fi
