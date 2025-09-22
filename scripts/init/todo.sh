#!/usr/bin/env bash

exit 0

# ------------ 修改 xdg-user-dirs-update 语言 ------------

LANG=en_US.UTF-8 xdg-user-dirs-update --force

cat ~/.config/user-dirs.dirs

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

# 安装后的 dnf 代理设置

# 看看要不要先删除一些软件再进行 install, 看 obsidian 中的 KDE_install_doc: dnf basic

# todo: 不知道要不要安装
# xdg-utils
# 如果您使用 Wayland + Flatpak/沙箱应用，很多应用会调用 xdg-utils 来打开文件、浏览器或邮件客户端。

# 尝试不显式安装 xdg-desktop-portal-hyprland, 这个会不会存在

# 看看有没有误装 ffmpeg-free

# 看看自带了哪些 字体

# 看看 power-profiles-daemon upower acpid