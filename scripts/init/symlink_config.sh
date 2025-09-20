#!/usr/bin/env bash

command rm -rf ~/.cache/fastfetch && \
command rm -rf ~/.config/fastfetch && \
ln -s ~/workspace/dev/mjj-config/fastfetch ~/.config/fastfetch
echo "--- fastfetch 配置已链接 ---"

command rm -rf ~/.config/fd && \
ln -s ~/workspace/dev/mjj-config/fd ~/.config/fd
echo "--- fd 配置已链接 ---"

command rm -rf ~/.config/hypr && \
ln -s ~/workspace/dev/mjj-config/hypr ~/.config/hypr
echo "--- hypr 配置已链接 ---"

command rm -rf ~/.config/kitty && \
ln -s ~/workspace/dev/mjj-config/kitty ~/.config/kitty
echo "--- kitty 配置已链接 ---"

command rm -rf ~/.config/mako && \
ln -s ~/workspace/dev/mjj-config/mako ~/.config/mako
echo "--- mako 配置已链接 ---"

command rm -rf ~/.config/mpv && \
ln -s ~/workspace/dev/mjj-config/mpv ~/.config/mpv
echo "--- mpv 配置已链接 ---"

command rm -rf ~/.config/navi && \
ln -s ~/workspace/dev/mjj-config/navi ~/.config/navi
echo "--- navi 配置已链接 ---"

command rm -rf \
        ~/.config/nvim \
        ~/.local/share/nvim \
        ~/.local/state/nvim \
        ~/.cache/nvim && \
ln -s ~/workspace/dev/mjj-config/nvim ~/.config/nvim
echo "--- nvim 配置已链接 ---"

command rm -rf ~/.config/rofi && \
ln -s ~/workspace/dev/mjj-config/rofi ~/.config/rofi
echo "--- rofi 配置已链接 ---"

command rm -rf ~/.config/waybar && \
ln -s ~/workspace/dev/mjj-config/waybar ~/.config/waybar
echo "--- waybar 配置已链接 ---"

command rm -rf ~/.config/yt-dlp && \
ln -s ~/workspace/dev/mjj-config/yt-dlp ~/.config/yt-dlp
echo "--- yt-dlp 配置已链接 ---"
