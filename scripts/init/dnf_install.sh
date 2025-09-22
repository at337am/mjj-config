#!/usr/bin/env bash

# 设置严格模式，任何错误都会导致脚本退出
set -euo pipefail

log() {
    echo "-=> $1 <=-"
}

log "安装 RPM Fusion 仓库..."
sudo dnf -y install \
    "https://mirror.math.princeton.edu/pub/rpmfusion/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" \
    "https://mirror.math.princeton.edu/pub/rpmfusion/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"

# 更多镜像地址: https://mirrors.rpmfusion.org/mm/publiclist

# bak: CN 镜像
# sudo dnf install \
#     "https://mirrors.ustc.edu.cn/rpmfusion/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
#     "https://mirrors.ustc.edu.cn/rpmfusion/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

log "启用 Hyprland 的 copr 仓库..."
sudo dnf -y copr enable solopasha/hyprland

log "启用 eza 的 copr 仓库..."
sudo dnf -y copr enable alternateved/eza




# ------------ INSTALL ------------

log "安装基础组..."
sudo dnf -y group install \
    "c-development" \
    "development-tools" \
    "multimedia"

# 因为上面 multimedia 安装了旧的 libva-intel-media-driver
# 需要先删除, 下面会安装新的 intel-media-driver 以适应 Intel 5 代以上的机型
# 参考: https://github.com/devangshekhawat/Fedora-42-Post-Install-Guide?tab=readme-ov-file#hw-video-decoding-with-va-api
log "卸载不需要的 libva-intel-media-driver..."
sudo dnf -y remove libva-intel-media-driver

log "安装显卡驱动..."
sudo dnf -y install \
    glx-utils \
    intel-media-driver \
    libva-intel-driver \
    libva-utils \
    mesa-vdpau-drivers \
    vulkan-tools


# -----------------------


log "安装字体和鼠标主题..."
sudo dnf -y install \
    adwaita-sans-fonts.noarch \
    breeze-cursor-theme \
    google-noto-color-emoji-fonts \
    google-noto-sans-cjk-fonts

log "安装基础软件包..."
sudo dnf -y install \
    adb \
    bat \
    cargo \
    catimg \
    cava \
    chafa \
    cmatrix \
    eza \
    fastfetch \
    fcitx5 \
    fcitx5-configtool \
    fcitx5-gtk \
    fcitx5-qt \
    fcitx5-rime \
    fd-find \
    ffmpeg \
    figlet \
    flatpak \
    fzf \
    go \
    htop \
    ImageMagick \
    just \
    kitty \
    mpv \
    navi \
    neovim \
    p7zip \
    pandoc \
    qimgv \
    ripgrep \
    rust \
    tealdeer \
    tmux \
    uv \
    zsh

log "安装 Hyprland 及相关软件包..."
sudo dnf -y install \
    cliphist \
    grim \
    hypridle \
    hyprland \
    hyprlock \
    hyprpaper \
    libnotify \
    lxqt-policykit \
    mako \
    network-manager-applet \
    qt5-qtwayland \
    qt6-qtwayland \
    rofi-wayland \
    slurp \
    waybar \
    wev \
    wl-clipboard \
    xdg-desktop-portal-hyprland

