#!/usr/bin/env bash

if pgrep -x rofi > /dev/null
then
    pkill -x rofi
else
    rofi -show window -show-icons -window-format '{t}'
fi
