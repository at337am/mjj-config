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






# ----------------------------------------------------------- #


# 执行脚本
./install.sh 2>&1 | tee ~/install_output.log


# ---------------- 流程 ----------------

# 安装完 fedroa 系统时 (插网线或者连接 wifi ), 先设置代理环境, 先进行 dnf upgrade , 

# 重启电脑

# 再次设置代理环境

# 上传 mjj-config, fonts_fot_linux, ssh 等

# 解压 mjj-config 运行 setup_basic 脚本

# 解压 fonts_for_linux, 解压 ssh, 重新解压 mjj-config 到各自的位置

# 再启动 install 脚本.   脚本执行前   fonts 和 mjj-config 是否已经到位


# 注意事项: 安装完后检查是否误装 ffmpeg-free






# ------------- todo -------------

# 安装后的 dnf 代理设置 脚本

# 脚本 执行前 可以先  sudo dnf autoremove

# 改一下 fonts_for_linux .,  要求 解压后必须是 fonts 目录

# 脚本 前面 增加 rpm fussion 检查  存在 仓库就不执行
# setup_basic 也增加 检查  存在不执行
# 还有其他脚本  文件都加上检查

