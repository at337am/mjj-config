#!/usr/bin/env bash

# 设置目标目录
TARGET_DIR="/opt/soft/XHS-Downloader"

# 检查是否存在该目录
if [ -d "$TARGET_DIR" ]; then
  # 进入目录
  cd "$TARGET_DIR" || exit 1
  
  # 激活虚拟环境
  source .venv/bin/activate

  # 运行 Python 脚本
  python main.py
else
  echo "目录 $TARGET_DIR 不存在，无法继续执行。"
  exit 1
fi

