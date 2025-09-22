#!/usr/bin/env bash

# 设置严格模式，任何错误都会导致脚本退出
set -euo pipefail

log() {
    printf '\n-=> %s <=-\n' "$1"
}

enable_copr_repo() {
    local repo_owner="$1"
    local repo_project="$2"
    local repo_pattern="${repo_owner}:${repo_project}" # 例如 "solopasha:hyprland"

    if ! dnf repolist | grep -q "$repo_pattern"; then
        log "正在启用 ${repo_pattern} 的 copr 仓库..."
        if sudo dnf -y copr enable "${repo_owner}/${repo_project}"; then
            log "${repo_pattern} 的 copr 仓库已启用成功"
        else
            log "错误: 启用 ${repo_pattern} 的 copr 仓库失败!"
            return 1
        fi
    else
        log "${repo_pattern} 的 copr 仓库已启用, 跳过"
    fi
}


# ------------------------------- COPR -------------------------------


log "开始安装 RPM Fusion 仓库..."

# 更多镜像地址: https://mirrors.rpmfusion.org/mm/publiclist

# bak: CN 镜像
# sudo dnf install \
#     "https://mirrors.ustc.edu.cn/rpmfusion/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
#     "https://mirrors.ustc.edu.cn/rpmfusion/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

sudo dnf -y install \
    "https://mirror.math.princeton.edu/pub/rpmfusion/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" \
    "https://mirror.math.princeton.edu/pub/rpmfusion/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"

log "RPM Fusion 仓库已安装"

enable_copr_repo "solopasha" "hyprland"
enable_copr_repo "alternateved" "eza"

log "正在更新 DNF 缓存..."

sudo dnf makecache

log "所有仓库已准备就绪"


# ------------------------------- INSTALL -------------------------------



# -------------------------------- #
log "开始安装基础软件组..."

sudo dnf -y group install \
    "c-development" \
    "development-tools" \
    "multimedia"

log "基础软件组已安装完毕"
# -------------------------------- #



# -------------------------------- #
log "开始卸载不需要的 libva-intel-media-driver..."

# 因为上面 multimedia 安装了旧的 libva-intel-media-driver
# 需要先删除, 下面会安装新的 intel-media-driver 以适应 Intel 5 代以上的机型
# 参考: https://github.com/devangshekhawat/Fedora-42-Post-Install-Guide?tab=readme-ov-file#hw-video-decoding-with-va-api
sudo dnf -y remove libva-intel-media-driver

log "已卸载完毕: libva-intel-media-driver"
# -------------------------------- #



# -------------------------------- #
log "开始安装图形与硬件加速相关的软件包..."

sudo dnf -y install \
    glx-utils \
    intel-media-driver \
    libva-intel-driver \
    libva-utils \
    mesa-vdpau-drivers \
    vulkan-tools

log "图形与硬件加速相关的软件包已安装完毕"
# -------------------------------- #



# -------------------------------- #
log "开始安装字体和鼠标指针主题..."

sudo dnf -y install \
    adwaita-sans-fonts.noarch \
    breeze-cursor-theme \
    google-noto-color-emoji-fonts \
    google-noto-sans-cjk-vf-fonts

log "字体和鼠标指针主题已安装完毕"
# -------------------------------- #



# -------------------------------- #
log "开始安装常用软件包..."

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
    yt-dlp \
    zsh

log "常用软件包已安装完毕"
# -------------------------------- #



# -------------------------------- #
log "开始安装 Hyprland 及相关软件包..."

sudo dnf -y install \
    cliphist \
    grim \
    hypridle \
    hyprland \
    hyprlock \
    hyprpaper \
    lxqt-policykit \
    mako \
    network-manager-applet \
    qt5-qtwayland \
    qt6-qtwayland \
    rofi-wayland \
    slurp \
    waybar \
    wev \
    wl-clipboard

log "Hyprland 及相关软件包已安装完毕"
# -------------------------------- #



# -------------------------------- #
log "开始安装 ACPI 事件守护进程和电源配置服务..."

sudo dnf -y install \
    acpid \
    power-profiles-daemon

log "ACPI 事件守护进程和电源配置服务已安装完毕"
# -------------------------------- #



# -------------------------------- #
log “开始启用 ACPI 事件守护进程和电源配置服务”

if systemctl is-enabled --quiet power-profiles-daemon.service; then
    echo "power-profiles-daemon.service 已启用, 跳过"
else
    sudo systemctl enable --now power-profiles-daemon.service
    echo "power-profiles-daemon.service 已启用"
fi

if systemctl is-enabled --quiet acpid.service; then
    echo "acpid.service 已启用, 跳过"
else
    sudo systemctl enable --now acpid.service
    echo "acpid.service 已启用"
fi
# -------------------------------- #



# -------------------------------- #
log “开始清理无用软件包”

sudo dnf -y autoremove

log “无用软件包已清理完毕”
# -------------------------------- #
