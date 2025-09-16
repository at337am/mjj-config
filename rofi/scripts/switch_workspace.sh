#!/usr/bin/env bash

if pgrep -x rofi > /dev/null; then
    pkill -x rofi
    exit 0
fi

# rofi -show window -show-icons -window-format '{t}'

workspaces=$(hyprctl workspaces -j | jq -r 'sort_by(.id) | .[] | select(.name | startswith("special:") | not) | "\(.id)\t\(.lastwindowtitle)"')

chosen_index=$(echo -e "$workspaces" | rofi -dmenu -i -p "workspaces" -format 'i' -no-show-icons -kb-accept-entry 'Return')

if [ -z "$chosen_index" ]; then
    exit 0
fi

target_line=$(echo -e "$workspaces" | sed -n "$((chosen_index + 1))p")
workspace_id=$(echo "$target_line" | awk '{print $1}')

hyprctl dispatch workspace "$workspace_id"
