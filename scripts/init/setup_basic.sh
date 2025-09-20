#!/usr/bin/env bash

sudo systemctl stop firewalld && \
sudo systemctl disable firewalld
echo "-=> 防火墙已关闭 <=-"

sudo timedatectl set-local-rtc '0'
echo "-=> 已将硬件时钟设置为 UTC <=-"

echo 'Defaults    timestamp_timeout=60' | sudo tee -a /etc/sudoers
echo 'Defaults    !tty_tickets' | sudo tee -a /etc/sudoers
echo "-=> 已将 sudo 过期时间设置为 60 分钟 <=-"

echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/sbin/shutdown" | sudo tee -a /etc/sudoers
echo "-=> 已设置免密关机 <=-"

sudo mkdir -p /workspace/dev /workspace/tmp && \
sudo chown -R $(whoami):$(id -gn) /workspace && \
ln -s /workspace ~/workspace

sudo mkdir -p /data/bak/restore /data/hello /data/misc/tgboom && \
sudo chown -R $(whoami):$(id -gn) /data

sudo mkdir -p /opt/soft /opt/venvs && \
sudo chown -R $(whoami):$(id -gn) /opt/soft /opt/venvs

echo "-=> 已创建 个人偏好 的目录结构 <=-"




# todo, 修改 xdg-user-dirs-update 语言:

# LANG=en_US.UTF-8 xdg-user-dirs-update --force && cat ~/.config/user-dirs.dirs

# mv -n ~/下载/* ~/Downloads/; \
# mv -n ~/文档/* ~/Documents/; \
# mv -n ~/图片/* ~/Pictures/; \
# mv -n ~/视频/* ~/Videos/; \
# mv -n ~/音乐/* ~/Music/; \
# mv -n ~/模板/* ~/Templates/; \
# mv -n ~/公共/* ~/Public/; \
# mv -n ~/桌面/* ~/Desktop/; \
# command rm -rfv ~/下载 ~/文档 ~/图片 ~/视频 ~/音乐 ~/模板 ~/公共 ~/桌面
