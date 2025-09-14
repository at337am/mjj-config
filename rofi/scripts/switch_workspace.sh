#!/usr/bin/env bash

if pgrep -x rofi > /dev/null; then
    pkill -x rofi
    exit 0
fi

# rofi -show window -show-icons -window-format '{t}'

workspaces=$(hyprctl workspaces -j | jq -r 'sort_by(.id) | .[] | "\(.id)\t\(.lastwindowtitle)"')

# 2. 将列表传给 rofi
#    -dmenu: dmenu 模式
#    -i: 不区分大小写
#    -p: 提示符
#    -format 'i': 让 rofi 只输出选中项的索引号 (0, 1, 2...)
#    -no-show-icons: 明确禁用图标，加快渲染
#    -kb-accept-entry "!-L,Return": 修复一些 rofi 版本的回车问题
chosen_index=$(echo -e "$workspaces" | rofi -dmenu -i -p "workspace" -format 'i' -no-show-icons -kb-accept-entry 'Return')

# 3. 如果没选，就退出
if [ -z "$chosen_index" ]; then
    exit 0
fi

# 4. 根据 rofi 返回的索引号，从原始列表中提取出对应行的 ID
#    因为 jq 已经按 id 排序了，所以索引号 0 对应 id 1, 索引号 1 对应 id 2...
#    但为了安全起见，我们直接从原始列表里找。
#    `sed -n "${chosen_index}p"` 会打印第 N 行 (N是索引号)
#    `awk '{print $1}'` 提取该行的第一个字段（也就是ID）
#    注意: sed 的行号是从 1 开始的，而 rofi 的索引是从 0 开始的，所以要+1
target_line=$(echo -e "$workspaces" | sed -n "$((chosen_index + 1))p")
workspace_id=$(echo "$target_line" | awk '{print $1}')


# 5. 跳转
#    使用 hyprctl batch 可以稍微提高一点性能，因为它保持一个连接
#    但对于单条命令，dispatch 足够快且简单
hyprctl dispatch workspace "$workspace_id"
