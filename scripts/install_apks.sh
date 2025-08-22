#!/bin/sh

# 遍历当前目录下所有 .apk 后缀的文件
for apk in *.apk
do
  # 检查文件是否存在
  [ ! -f "$apk" ] && continue

  echo "--> 正在安装: $apk"
  adb install -r "$apk" && echo "    安装成功" || echo "    安装失败"
  echo "---------------"
done

echo "所有 APK 安装任务已完成"
