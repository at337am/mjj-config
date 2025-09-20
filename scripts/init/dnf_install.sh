#!/usr/bin/env bash

echo "-=> 正在安装 RPM Fusion 仓库 <=-"
sudo dnf -y install \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

sudo dnf -y install \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"

echo "-=> 正在启用 Hyprland 的 copr 仓库 <=-"
sudo dnf copr enable solopasha/hyprland

echo "-=> 正在启用 eza 的 copr 仓库 <=-"
sudo dnf copr enable alternateved/eza

# ---------------------

echo "-=> 正在安装基础工具 <=-"
sudo dnf -y group install "c-development" "development-tools"

echo "-=> 正在安装字体文件 <=-"
sudo dnf -y install \
    adwaita-sans-fonts.noarch \
    google-noto-color-emoji-fonts

echo "-=> 正在安装显卡驱动 <=-"
sudo dnf install \
    mesa-dri-drivers-25.1.9-1.fc42.x86_64 \
    mesa-vulkan-drivers-25.1.9-1.fc42.x86_64 \
    mesa-libGL-25.1.9-1.fc42.x86_64 \
    mesa-libEGL-25.1.9-1.fc42.x86_64 \
    libva-utils-2.22.0-4.fc42.x86_64 \
    mesa-va-drivers-25.1.9-1.fc42.x86_64 \

echo "-=> 正在安装基础软件包 <=-"
sudo dnf -y install \
    zsh \
    git \
    neovim \
    htop \
    fastfetch \
    go \
    kitty \
    catimg \
    pandoc \
    mpv \
    qimgv \
    uv \
    rust \
    cargo \
    bat \
    ripgrep \
    fd-find \
    fzf \
    eza \
    chafa \
    figlet \
    just \
    tealdeer \
    cava \
    navi \
    adb

echo "-=> 正在安装 Hyprland 及相关软件包 <=-"
sudo dnf -y install \
    hyprland \
    hyprpaper \
    hyprlock \
    hypridle \
    qt5-qtwayland \
    qt6-qtwayland \
    xdg-desktop-portal-hyprland \
    lxqt-policykit \
    libnotify \
    network-manager-applet \
    rofi-wayland \
    waybar \
    cliphist \
    wl-clipboard \
    grim \
    slurp \
    wev \
    mako \
    cmatrix

echo "-=> 正在安装 Breeze 光标主题 <=-"
sudo dnf -y install breeze-cursor-theme

echo "-=> 正在安装 fcitx5 输入法 <=-"
sudo dnf install \
    fcitx5 \
    fcitx5-configtool \
    fcitx5-gtk \
    fcitx5-qt \
    fcitx5-rime

# todo: 字体
# Noto Color Emoji

# todo: ~/Desktop、~/Documents 等目录
# sudo dnf install xdg-user-dirs
