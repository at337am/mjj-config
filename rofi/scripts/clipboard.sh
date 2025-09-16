#!/usr/bin/env bash

if pgrep -x rofi > /dev/null; then
    pkill -x rofi
    exit 0
fi

cliphist list | rofi -dmenu -i -p "clipboard" | cliphist decode | wl-copy

# todo
# if cliphist list | rofi -dmenu -p "Clipboard" | cliphist decode | wl-copy; then
#     notify-send -a "clipboard" \
#                 -u low \
#                 "📋  Copied"
# else
#     notify-send -a "clipboard" \
#                 -u low \
#                 "Copy Failed"
# fi
