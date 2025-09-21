#!/usr/bin/env bash

# 设置严格模式，任何错误都会导致脚本退出
set -euo pipefail

log() {
    echo "-=> $1 <=-"
}

log "安装 RPM Fusion 仓库..."
sudo dnf install \
    "https://mirror.math.princeton.edu/pub/rpmfusion/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" \
    "https://mirror.math.princeton.edu/pub/rpmfusion/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"

# 更多镜像地址: https://mirrors.rpmfusion.org/mm/publiclist

# bak: CN 镜像
# sudo dnf install \
#     "https://mirrors.ustc.edu.cn/rpmfusion/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
#     "https://mirrors.ustc.edu.cn/rpmfusion/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

log "启用 Hyprland 的 copr 仓库..."
sudo dnf copr enable solopasha/hyprland

log "启用 eza 的 copr 仓库..."
sudo dnf copr enable alternateved/eza




# ------------ INSTALL ------------

log "安装基础组..."
sudo dnf group install \
    "c-development" \
    "development-tools" \
    "multimedia"

log "安装显卡驱动..."
sudo dnf install \
    mesa-dri-drivers-25.1.9-1.fc42.x86_64 \
    mesa-vulkan-drivers-25.1.9-1.fc42.x86_64 \
    mesa-libGL-25.1.9-1.fc42.x86_64 \
    mesa-libEGL-25.1.9-1.fc42.x86_64 \
    libva-utils-2.22.0-4.fc42.x86_64 \
    mesa-va-drivers-25.1.9-1.fc42.x86_64 \
    glx-utils \
    vulkan-tools \
    mesa-vdpau-drivers \
    intel-media-driver \
    ffmpeg-libs \
    libva \
    libva-utils \
    libva-intel-driver \
    openh264 \
    gstreamer1-plugin-openh264

# 因为上面 multimedia 安装了旧的, 需要替换为新的, 来适应 intel 5 代以上的机型
# 参考: https://github.com/devangshekhawat/Fedora-42-Post-Install-Guide?tab=readme-ov-file#hw-video-decoding-with-va-api
sudo dnf swap libva-intel-media-driver intel-media-driver --allowerasing

log "安装字体和鼠标主题..."
sudo dnf install \
    adwaita-sans-fonts.noarch \
    google-noto-sans-cjk-fonts \
    google-noto-color-emoji-fonts \
    breeze-cursor-theme \


# -----------------------

log "安装基础软件包..."
sudo dnf install \
    adb \
    bat \
    cargo \
    catimg \
    cava \
    chafa \
    eza \
    fastfetch \
    fd-find \
    figlet \
    flatpak \
    fzf \
    git \
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
    uv \
    zsh

log "安装 Hyprland 及相关软件包..."
sudo dnf install \
    cliphist \
    cmatrix \
    fcitx5 \
    fcitx5-configtool \
    fcitx5-gtk \
    fcitx5-qt \
    fcitx5-rime
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
    xdg-desktop-portal-hyprland \



# ------------- todo -------------

# todo: 不知道要不要安装, 不确定是否已经安装
# wireplumber
# pipewire
# xdg-utils
# xdg-user-dirs
