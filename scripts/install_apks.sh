#!/usr/bin/env bash

success=0
fail=0

# 遍历当前目录下所有 .apk 后缀的文件
for apk in *.apk
do
  # 检查是否存在文件
  [ ! -f "$apk" ] && continue

  echo "--> $apk"

  if adb install -r "$apk"; then
    echo "    安装成功"
    success=$((success + 1))
  else
    echo "    安装失败"
    fail=$((fail + 1))
  fi
  echo "----------------"
done

echo
echo "--- 执行完毕 ---"
echo "Succeeded: ${success}"
echo "Failed: ${fail}"
