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


# 不需要: ~/Desktop, ~/Public, ~/Templates



# ----------------------------------------------------------- #


# 测试 执行脚本
./install.sh 2>&1 | tee ~/install_output.log


# ---------------- 流程 ----------------

# ## 注意事项: 安装完后检查是否误装 ffmpeg-free


# ## 准备工作:
# fonts_for_linux.tar.gz
# ssh
# nekoray.tar.gz
# mjj-config.tar.gz
# config_baks_for_linux.tar


# ## 开始安装:

# 安装完 fedroa 系统后 (插网线或者连接 wifi )

# 先设置代理环境

# 更新全部软件包 sudo dnf -y upgrade

# 重启电脑

# 再次设置代理环境

# 使用 scp -r 上传 mjj-config, fonts_fot_linux, ssh, nekoray 等, 放在 ~/pkgs 目录中

# 解压 mjj-config 运行 setup_basic.sh 脚本

# 再启动 bootstrap.sh 脚本




# ------------- todo -------------

# 安装后的 xdg-user-dirs-update 语言

# init/scripts 中的所有脚本都需要 无痛执行, 就是可以重复执行的

# 脚本执行前   fonts 和 mjj-config 是否已经到位

# 把所有准备材料都可以放在一起, 直接用脚本执行得了
# 增加检查就行了, 能细分的就不要写在一起, 解耦
# 有些 workspace 的文件路径可以改为相对路径

# 如果 .local/bin 不在 path 中则 加入path
