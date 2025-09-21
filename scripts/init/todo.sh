#!/usr/bin/env bash

exit 0

# ------------ 修改 xdg-user-dirs-update 语言 ------------

LANG=en_US.UTF-8 xdg-user-dirs-update --force

mv -n ~/下载/* ~/Downloads/
mv -n ~/文档/* ~/Documents/
mv -n ~/图片/* ~/Pictures/
mv -n ~/视频/* ~/Videos/
mv -n ~/音乐/* ~/Music/
mv -n ~/模板/* ~/Templates/
mv -n ~/公共/* ~/Public/
mv -n ~/桌面/* ~/Desktop/

command rm -rfv ~/下载 ~/文档 ~/图片 ~/视频 ~/音乐 ~/模板 ~/公共 ~/桌面


# ------------- 移除 ffmpeg-free -------------
sudo dnf remove ffmpeg-free
sudo dnf install ffmpeg --allowerasing


# ------------- 核心电源管理和 ACPI 服务 -------------

# sudo dnf remove tuned-ppd

sudo dnf install \
    acpid \
    power-profiles-daemon \
    upower

sudo systemctl enable --now power-profiles-daemon.service
sudo systemctl enable --now acpid.service



# ------------- todo -------------

# todo: 不知道要不要安装, 不确定是否已经安装
# wireplumber
# pipewire
# xdg-utils
# xdg-user-dirs


# 尝试不显式安装 xdg-desktop-portal-hyprland, 这个会不会存在
