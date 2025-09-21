#!/usr/bin/env bash

# 设置严格模式，任何错误都会导致脚本退出
set -euo pipefail

log() {
    echo "-=> $1 <=-"
}

log "正在安装 RPM Fusion 仓库"
sudo dnf install \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

sudo dnf install \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"

log "正在启用 Hyprland 的 copr 仓库"
sudo dnf copr enable solopasha/hyprland

log "正在启用 eza 的 copr 仓库"
sudo dnf copr enable alternateved/eza




# ------------ INSTALL ------------

log "正在安装基础组"
sudo dnf group install \
    "c-development" \
    "development-tools" \
    "multimedia"

log "正在安装显卡驱动"
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

log "正在安装字体和鼠标主题"
sudo dnf install \
    adwaita-sans-fonts.noarch \
    google-noto-sans-cjk-fonts \
    google-noto-color-emoji-fonts \
    breeze-cursor-theme \


# -----------------------

log "正在安装基础软件包"
sudo dnf install \
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
    adb \
    ImageMagick \
    htop \
    p7zip \
    flatpak

log "正在安装 Hyprland 及相关软件包"
sudo dnf install \
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
    cmatrix \
    fcitx5 \
    fcitx5-configtool \
    fcitx5-gtk \
    fcitx5-qt \
    fcitx5-rime



# ------------- todo -------------

# todo: 不知道要不要安装, 不确定是否已经安装
# wireplumber
# pipewire
# xdg-utils
# xdg-user-dirs
