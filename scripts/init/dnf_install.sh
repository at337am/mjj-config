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




# ------------ INSTALL ------------

echo "-=> 正在安装基础组 <=-"
sudo dnf -y group install \
    "c-development" \
    "development-tools" \
    "multimedia"

echo "-=> 正在安装显卡驱动 <=-"
sudo dnf -y install \
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

echo "-=> 正在安装字体和鼠标主题 <=-"
sudo dnf -y install \
    adwaita-sans-fonts.noarch \
    google-noto-sans-cjk-fonts \
    google-noto-color-emoji-fonts \
    breeze-cursor-theme \


# -----------------------

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
    cmatrix \
    fcitx5 \
    fcitx5-configtool \
    fcitx5-gtk \
    fcitx5-qt \
    fcitx5-rime





# ------------- 核心电源管理和 ACPI 服务 -------------

# sudo dnf remove tuned-ppd

# sudo dnf install \
#     power-profiles-daemon \
#     acpid \
#     upower

# sudo systemctl enable --now power-profiles-daemon.service
# sudo systemctl enable --now acpid.service




# ------------- todo -------------

# todo: 不知道要不要安装, 不确定是否已经安装
# wireplumber
# pipewire
# xdg-utils
# xdg-user-dirs
