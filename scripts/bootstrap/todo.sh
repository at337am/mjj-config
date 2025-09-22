#!/usr/bin/env bash

exit 0



# 测试 执行脚本
./install.sh 2>&1 | tee ~/install_output.log



# ------------ 修改 xdg-user-dirs-update 语言 START ------------

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

# ------------ 修改 xdg-user-dirs-update 语言 END ------------






# ---------------- 流程 START ----------------

# ## 注意事项: 安装完后检查是否误装 ffmpeg-free


## 准备工作:
# pkgs/ssh.tar
# pkgs/fonts.tar.gz
# pkgs/nekoray.tar.gz

# dots.tar.gz
# config_baks_for_linux.tar


## 开始安装:

# 安装完 fedroa 系统后 (插网线或者连接 wifi )

# 先设置代理环境

# 更新全部软件包 sudo dnf -y upgrade

# 重启电脑

# 再次设置代理环境

# 使用 scp -r 上传 所有所需文件到 ~/ 目录下

# 就地解压 dots, 然后执行 bootstrap.sh 脚本

# 执行完成后都正常的话就可以重启进入 GUI 了

# 启动 nekoray

# 手动按顺序执行 tasks/gui 中的脚本

# 脚本执行完成后, 解压 config_baks_for_linux.tar, 手动配置 GUI

# ---------------- 流程 END ----------------





# ------------- 开发 todo -------------

# 完成 xdg-user-dirs-update 脚本, 放到 tasks/gui 中





# ------------- 测试 todo -------------

# 测试能否直接用 nekoray

# 脚本执行后 看看 xdg-user-dirs-update 配置
cat ~/.config/user-dirs.dirs

# 完成后检查 zsh 的 .lain 主题 是否正确设置
