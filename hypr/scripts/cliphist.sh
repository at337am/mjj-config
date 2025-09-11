#!/usr/bin/env bash

if pgrep -x rofi > /dev/null
then
    pkill -x rofi
else
    cliphist list | rofi -dmenu | cliphist decode | wl-copy
fi
