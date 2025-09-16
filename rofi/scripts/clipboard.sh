#!/usr/bin/env bash

if pgrep -x rofi > /dev/null; then
    pkill -x rofi
    exit 0
fi

if cliphist list | rofi -dmenu | cliphist decode | wl-copy; then
    notify-send -a "clipboard" \
                -u low \
                "📋  Copied"
else
    notify-send -a "clipboard" \
                -u low \
                "Copy Failed"
fi
