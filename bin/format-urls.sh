#!/usr/bin/env bash

if [[ "$#" -ne 1 ]]; then
    printf "参数错误\n" >&2
    printf "用法: %s <链接文件>\n" "format_xhs_url.sh" >&2
    exit 1
fi

INPUT_PATH="$1"

# 检查输入文件是否存在
if [[ ! -f "$INPUT_PATH" ]]; then
    printf "Error: 无法打开输入文件: %s\n" "$INPUT_PATH" >&2
    exit 1
fi

output_path="$(dirname "$INPUT_PATH")/furls_result.txt"

# -o 仅输出匹配部分
links=$(rg -o 'https://www\.xiaohongshu\.com/discovery/item/[^\s]+' "$INPUT_PATH")

# 将所有链接用空格连接并写入输出文件
echo "$links" | tr '\n' ' ' > "$output_path"

printf "链接格式已整理 -> %s\n" "$output_path"
