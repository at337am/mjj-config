# 暂时不确定要不要
# if [[ ! "$PATH" =~ "/sbin" ]]; then
#   export PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin"
# fi

export LANG="zh_CN.UTF-8"

if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    echo "Enjoy Hyprland!"
    exec dbus-run-session Hyprland
fi
