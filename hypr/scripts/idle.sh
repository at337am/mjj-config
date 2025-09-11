#!/usr/bin/env bash

LOCK_CMD="swaylock -f --image ~/Pictures/PFP/wallhaven-ogd28l.png"

# 1. 锁屏
# 2. 熄屏, 在锁屏后一分钟
# 3. 重新唤起屏幕
# 4. 电源键按下后在进入睡眠前先锁屏
swayidle -w \
        timeout 300 "$LOCK_CMD" \
        timeout 360 'hyprctl dispatch dpms off' \
        resume 'hyprctl dispatch dpms on' \
        before-sleep "$LOCK_CMD"
