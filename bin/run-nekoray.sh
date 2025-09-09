#!/usr/bin/env bash

session="nekoray"
nekoray_path="/opt/soft/nekoray/nekoray"

# 检查会话是否存在
if tmux has-session -t "$session" 2>/dev/null; then
    printf "%s already exists, recreating...\n" "$session"
    tmux kill-session -t "$session"
fi

# 启动新会话
tmux new-session -d -s "$session" "$nekoray_path"

exit 0
