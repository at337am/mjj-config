#!/usr/bin/env bash

TARGET_DIR="/opt/soft/hello-server"
LOG_FILE="run.log" # 日志文件名, 它将创建在 TARGET_DIR 目录下

# 检查是否已有 hello 进程在运行
if pgrep -f "./hello" > /dev/null 2>&1; then
    printf "🫠 Hey, the hello server is already running. Bye!\n"
    exit 0
fi

printf "🎐 Heading into %s ...\n" "$TARGET_DIR"

# 使用 pushd 进入目标目录
if ! pushd "$TARGET_DIR" > /dev/null 2>&1; then
    printf "🤯 Oops! Can't get into '%s'.\n" "$TARGET_DIR" >&2
    printf "🧐 Check if it exists and you have permission.\n" >&2
    exit 1
fi

# 此时, 当前工作目录已经是 /opt/soft/hello-server

printf "🦋 Starting up ./hello ...\n"

# 在 TARGET_DIR 目录下执行 nohup 命令
# run.log 文件将创建在 TARGET_DIR 中
nohup ./hello &> "$LOG_FILE" &

PID=$!


# 简单检查 PID 是否有效
if [ "$PID" -eq 0 ] || [ "$PID" -eq 1 ]; then
    printf "🤯 Uh-oh, the server didn't start right.\n" >&2
    printf "🧐 Check the logs: '%s/%s'\n" "$TARGET_DIR" "$LOG_FILE" >&2
    popd > /dev/null 2>&1
    exit 1
fi

# 使用 popd 返回到原始目录
popd > /dev/null 2>&1

printf "💤 All set! hello server is running (PID: %d).\n" "$PID"
printf "📔 Logs are at: %s/%s\n" "$TARGET_DIR" "$LOG_FILE"

exit 0
