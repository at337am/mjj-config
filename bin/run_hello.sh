#!/bin/bash

TARGET_DIR="/opt/soft/hello-server"
LOG_FILE="run.log" # 日志文件名，它将创建在 TARGET_DIR 目录下
PROCESS_NAME="hello" # 要查找的进程名称

echo "💡 正在尝试进入目录并准备管理程序：$TARGET_DIR ..."

# 使用 pushd 进入目标目录。'> /dev/null 2>&1' 屏蔽 pushd 的默认输出。
# 如果 pushd 失败，返回非零状态码。
if ! pushd "$TARGET_DIR" > /dev/null 2>&1; then
    echo "❌ 错误：无法进入目录 '$TARGET_DIR'。" >&2
    echo "请确保该目录存在，并且您有权限访问。" >&2
    exit 1 # 无法进入目录，脚本退出
fi

# 此时，当前工作目录已经是 /opt/soft/hello-server

echo "✅ 成功进入目录 '$TARGET_DIR'。"

# --- 检查并终止现有进程 ---
echo "⏳ 正在检查是否存在『$PROCESS_NAME』进程..."

# 使用 ps -ef 查找进程，并通过grep过滤，awk提取PID
# 使用[h]ello的形式是为了避免匹配到grep命令自身
# 查找完整的路径匹配，增强准确性
# 过滤出PID (ps -ef 输出的第二列是PID)
PIDS_TO_KILL=$(ps -ef | grep "$TARGET_DIR/[h]$PROCESS_NAME" | awk '{print $2}')

if [ -n "$PIDS_TO_KILL" ]; then
    echo "⚠️ 发现现有『$PROCESS_NAME』进程 (PIDs: $PIDS_TO_KILL)。"
    echo "发送终止信号 (SIGTERM - kill -15) 以请求优雅关闭..."

    # 遍历所有找到的PID并发送信号
    for PID_TO_KILL in $PIDS_TO_KILL; do
        # 检查PID是否仍然存在（避免竞态条件）
        if ps -p "$PID_TO_KILL" > /dev/null; then
             echo "  - 正在终止 PID $PID_TO_KILL..."
             kill -15 "$PID_TO_KILL" || echo "  - 警告: 无法向 PID $PID_TO_KILL 发送终止信号。" >&2
        else
             echo "  - PID $PID_TO_KILL 不再存在，跳过终止。"
        fi
    done

    # 等待一段时间让进程处理信号并退出
    WAIT_TIME=0.5 # 等待0.5秒
    echo "等待 $WAIT_TIME 秒，以允许进程优雅关闭..."
    sleep "$WAIT_TIME"

    # 再次检查进程是否已经退出
    PIDS_AFTER_KILL=$(ps -ef | grep "$TARGET_DIR/[h]$PROCESS_NAME" | awk '{print $2}')
    if [ -n "$PIDS_AFTER_KILL" ]; then
         echo "❌ 警告: 部分现有进程未能终止 (剩余 PIDs: $PIDS_AFTER_KILL)。请手动检查或考虑使用 kill -9。" >&2
         # 注意：这里我们选择继续尝试启动新的进程，但给出警告。
         # 如果希望未能终止旧进程就停止，可以在这里加 exit 1
    else
         echo "✅ 现有进程已终止或已退出。"
    fi
else
    echo "✅ 未发现现有『$PROCESS_NAME』进程。"
fi
# --- 结束检查并终止现有进程 ---

echo "🚀 正在启动新的程序 './$PROCESS_NAME' ..."

# 在 TARGET_DIR 目录下执行 nohup 命令
# run.log 文件将创建在 TARGET_DIR 中
nohup ./$PROCESS_NAME &> "$LOG_FILE" &

# 捕获后台进程的 PID
PID=$!

# 简单检查新启动的进程 PID 是否有效
# 注意：即使nohup后面的命令执行失败，$!也可能是1或0
if [ "$PID" -eq 0 ] || [ "$PID" -eq 1 ]; then
     # 尝试更精确地检查进程是否存在
     if ! ps -p "$PID" > /dev/null; then
          echo "❌ 错误：新的程序可能未能成功启动（PID无效或进程不存在：$PID）。请检查日志文件 '$TARGET_DIR/$LOG_FILE'。" >&2
          popd > /dev/null 2>&1 # 尝试返回原始目录
          exit 1
     fi
fi


# 使用 popd 返回到原始目录
# '>' /dev/null 2>&1 屏蔽 popd 的默认输出。
popd > /dev/null 2>&1

# 输出成功信息
echo "✅ 程序『$PROCESS_NAME』已在后台运行！（PID: $PID）"
# 明确告诉用户日志文件在哪里
echo "📄 日志文件保存在：$TARGET_DIR/$LOG_FILE，请随时查看运行状态。😊"

exit 0 # 脚本成功完成
