#!/usr/bin/env bash

# 功能: 在 Linux Desktop 中使用默认浏览器一次性打开下面定义的所有URL。
# 使用方法:
# 1. 将此脚本保存为 open_urls.sh
# 2. 赋予执行权限: chmod +x open_urls.sh
# 3. 运行脚本: ./open_urls.sh

# --- 在此定义您想打开的网站列表 ---
URLS=(
    "https://aistudio.google.com"
    "https://alipan.com/drive/file/all"
    "https://apkcombo.com"
    "https://apkmirror.com"
    "https://archive.org"
    "https://bilibili.com"
    "https://bsky.app"
    "https://chatgpt.com"
    "https://claude.ai"
    "https://difftext.com"
    "https://discord.com/channels/@me"
    "https://drive.google.com/drive/my-drive"
    "https://dropbox.com"
    "https://flathub.org"
    "https://github.com"
    "https://google.com"
    "https://grok.com"
    "https://instagram.com"
    "https://mail.google.com"
    "https://music.163.com"
    "https://pinterest.com"
    "https://proton.me"
    "https://reddit.com"
    "https://speed.cloudflare.com"
    "https://styledown.io"
    "https://translate.google.com"
    "https://up.woozooo.com"
    "https://weibo.com"
    "https://x.com"
    "https://youtube.com"
)

echo "准备使用默认浏览器打开以下网站..."
echo "------------------------------------"

i=1

for url in "${URLS[@]}"; do
    echo "  -> 正在打开 ${i}. ${url}"
    # 使用 xdg-open 命令，它会自动调用系统的默认浏览器
    xdg-open "$url"
    ((i++))
done

echo "------------------------------------"
echo "操作完成！所有网站都已请求在浏览器中打开。"

