#!/usr/bin/env bash

# 检测 Rofi 是否运行
if pgrep -x rofi; then
    pkill -x rofi
else
    rofi -show drun
fi
