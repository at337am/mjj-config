#!/bin/sh
# KDE Plasma shutdown script to kill specific apps

apps_to_kill="nekoray Telegram"

for app in $apps_to_kill; do
    pkill -15 "$app"
done

# 不需要 sleep 或 exit 0，Plasma 会处理
