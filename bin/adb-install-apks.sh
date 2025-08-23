#!/usr/bin/env bash

success=0
fail=0

# 遍历当前目录下所有 .apk 后缀的文件
for apk in *.apk
do
  # 检查是否存在文件
  [ ! -f "$apk" ] && continue

  if adb install -r "$apk"; then
    printf "OK -> %s\n" "$apk"
    success=$((success + 1))
  else
    printf "ERR -> %s\n" "$apk"
    fail=$((fail + 1))
  fi
  printf "-------------\n"
done

printf "\n"
printf "--- Total ---\n"
printf "OK count: %d\n" "$success"
printf "ERR count: %d\n" "$fail"
