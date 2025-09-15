#!/usr/bin/env bash

if pgrep -x rofi > /dev/null; then
    pkill -x rofi
    exit 0
fi

# 设置存放 prompt 文件的目录路径
notes_path="$HOME/Documents/notes/prompts"

# Rofi 菜单的提示文字
rofi_prompt="选择一个 Prompt"

# --- 脚本主体 ---

# 1. 检查目录是否存在
if [ ! -d "$notes_path" ]; then
    # 如果目录不存在，通过 rofi 显示错误消息并退出
    rofi -e "错误: 目录未找到: $notes_path"
    exit 1
fi

# 2. 获取文件名列表并用 rofi 显示菜单
#    - `cd "$notes_path"`: 进入目标目录
#    - `ls -1`: 列出当前目录的文件，每行一个
#    - `(...)`: 将 cd 和 ls 放在子 shell 中执行，这样脚本的当前工作目录不会改变
#    - `rofi -dmenu -p "$rofi_prompt"`: 以 dmenu 模式启动 rofi，等待用户选择
#    - 将用户的选择存入 `selected_file` 变量
selected_file=$( (cd "$notes_path" && ls -1) | rofi -dmenu -i -p "$rofi_prompt")

# 3. 检查用户是否做出了选择 (如果按 Esc 键, selected_file 会为空)
if [ -z "$selected_file" ]; then
    # 用户取消了选择，静默退出
    exit 0
fi

# 4. 构建所选文件的完整路径
full_path="$notes_path/$selected_file"

# 5. 检查文件是否真实存在并且是一个普通文件
if [ -f "$full_path" ]; then
    # 6. 读取文件内容并通过 wl-copy 复制到剪贴板
    #    `< "$full_path"` 是一种比 `cat "$full_path" |` 更高效的重定向方式
    wl-copy < "$full_path"
    
    # 7. (可选) 发送桌面通知，提供操作反馈
    notify-send "✅ 复制成功" "已将 '$selected_file' 的内容复制到剪贴板。"
else
    # 如果选择的项不是一个有效的文件，显示错误
    notify-send "❌ 操作失败" "'$selected_file' 不是一个有效的文件。"
    exit 1
fi