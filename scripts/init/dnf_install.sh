#!/usr/bin/env bash

# 启动仓库
if sudo dnf repolist | grep -q "alternateved:eza"; then
    echo "-=> eza copr 仓库已启用，无需重复操作 <=-"
else
    echo "-=> 正在启用 eza 的 copr 仓库 <=-"
    sudo dnf copr enable alternateved/eza
fi

# 启动仓库
if sudo dnf repolist | grep -q "solopasha:hyprland"; then
    echo "-=> Hyprland copr 仓库已启用，无需重复操作 <=-"
else
    echo "-=> 正在启用 Hyprland 的 copr 仓库 <=-"
    sudo dnf copr enable solopasha/hyprland
fi

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
