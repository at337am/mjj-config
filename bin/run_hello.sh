#!/bin/bash

TARGET_DIR="/opt/soft/hello-server"
LOG_FILE="run.log" # 日志文件名，它将创建在 TARGET_DIR 目录下

# 检查是否已有 hello 进程在运行
if pgrep -f "./hello" > /dev/null 2>&1; then
    echo "💡 hello server 已在运行，跳过"
    exit 0
fi

echo "💡 正在尝试进入目录并启动程序：$TARGET_DIR ..."

# 使用 pushd 进入目标目录。'> /dev/null 2>&1' 屏蔽 pushd 的默认输出。
# 如果 pushd 失败，返回非零状态码。
if ! pushd "$TARGET_DIR" > /dev/null 2>&1; then
    echo "❌ 错误：无法进入目录 '$TARGET_DIR'。" >&2
    echo "请确保该目录存在，并且您有权限访问。" >&2
    exit 1 # 无法进入目录，脚本退出
fi

# 此时，当前工作目录已经是 /opt/soft/hello-server

echo "✅ 成功进入目录 '$TARGET_DIR'。"
echo "🚀 正在启动程序 './hello' ..."

# 在 TARGET_DIR 目录下执行 nohup 命令
# run.log 文件将创建在 TARGET_DIR 中
nohup ./hello &> "$LOG_FILE" &

# 捕获后台进程的 PID
PID=$!

# 简单检查 PID 是否有效
if [ "$PID" -eq 0 ] || [ "$PID" -eq 1 ]; then
     echo "❌ 错误：程序可能未能成功启动（PID无效）。请检查日志文件 '$TARGET_DIR/$LOG_FILE'。" >&2
     # 即使启动失败，也要尝试回到原始目录
     popd > /dev/null 2>&1
     exit 1
fi

# 使用 popd 返回到原始目录
# '>' /dev/null 2>&1 屏蔽 popd 的默认输出。
popd > /dev/null 2>&1

# 输出成功信息
echo "✅ 程序『hello』已在后台运行！（PID: $PID）"
# 明确告诉用户日志文件在哪里
echo "📄 日志文件保存在：$TARGET_DIR/$LOG_FILE，请随时查看运行状态。😊"

exit 0 # 脚本成功完成

