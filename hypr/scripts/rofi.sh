#!/usr/bin/env bash

if pgrep -x rofi > /dev/null; then
    pkill -x rofi
    exit 0
fi

rofi -show drun -theme ~/.config/rofi/themes/drun.rasi
