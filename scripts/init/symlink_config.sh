#!/usr/bin/env bash

command rm -rfv ~/.cache/fastfetch && \
command rm -rfv ~/.config/fastfetch && \
ln -s ~/workspace/dev/mjj-config/fastfetch ~/.config/fastfetch

command rm -rfv ~/.config/fd && \
ln -s ~/workspace/dev/mjj-config/fd ~/.config/fd

command rm -rfv ~/.config/hypr && \
ln -s ~/workspace/dev/mjj-config/hypr ~/.config/hypr


command rm -rfv ~/.config/kitty && \
ln -s ~/workspace/dev/mjj-config/kitty ~/.config/kitty


command rm -rfv ~/.config/mako && \
ln -s ~/workspace/dev/mjj-config/mako ~/.config/mako

command rm -rfv ~/.config/mpv && \
ln -s ~/workspace/dev/mjj-config/mpv ~/.config/mpv

command rm -rfv ~/.config/navi && \
ln -s ~/workspace/dev/mjj-config/navi ~/.config/navi

command rm -rfv \
        ~/.config/nvim \
        ~/.local/share/nvim \
        ~/.local/state/nvim \
        ~/.cache/nvim && \
ln -s ~/workspace/dev/mjj-config/nvim ~/.config/nvim

command rm -rfv ~/.config/rofi && \
ln -s ~/workspace/dev/mjj-config/rofi ~/.config/rofi

command rm -rfv ~/.config/waybar && \
ln -s ~/workspace/dev/mjj-config/waybar ~/.config/waybar

command rm -rfv ~/.config/yt-dlp && \
ln -s ~/workspace/dev/mjj-config/yt-dlp ~/.config/yt-dlp
