# ------------
#  Completion
# ------------

autoload -Uz compinit
compinit -u -C

WORDCHARS=''             # 移动光标时, 把 . / - 这些符号都视为单词的边界
unsetopt flowcontrol     # 禁用终端的 XON/XOFF 流控制功能, 防止 ctrl + s 终端输出停止
setopt complete_in_word  # 允许光标在单词中间时也能触发补全
setopt always_to_end     # 补全后将光标移动到单词末尾

# 菜单补全, 模糊补全, 目录补全顺序
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# ------------
#  directory
# ------------

setopt auto_cd                # 输入路径直接进入, 省去了 cd
setopt auto_pushd             # 将访问过的路径推入到堆栈
setopt pushd_ignore_dups      # 推入堆栈时忽略重复项
setopt pushdminus             # 开启 'pushd -' = 'cd -'

# ------------
#  history
# ------------

HISTFILE=$HOME/.zsh_history   # 历史命令文件路径
HISTSIZE=10000                # 内存中可保存的历史命令条数（即当前会话中可回溯的命令数）
SAVEHIST=10000                # 退出 shell 时保存到 HISTFILE 的历史命令条数

setopt extended_history       # 记录时间戳到历史记录中
setopt append_history         # 在退出时将历史记录追加到文件末尾，而不是覆盖整个文件, bak: inc_append_history
# setopt share_history          # 在多个并发运行的 zsh 会话之间共享历史记录
setopt hist_ignore_dups       # 忽略连续重复的命令
setopt hist_ignore_space      # 忽略以空格开头的命令
setopt no_bang_hist           # 关闭 !! 历史命令展开功能

# ------------
#  misc
# ------------

setopt long_list_jobs         # 使得后台任务状态变化的通知更详细
setopt interactivecomments    # 可以在命令行直接写 # 注释

export PAGER="${PAGER:-less}" LESS="${LESS:--R}"    # 使用 less 作为分页器, 默认为 -R, 显示颜色信息

# ------------
#  lib
# ------------

for lib_file ("$LAIN/lib"/*.zsh(N)); do
  source "$lib_file"
done
unset lib_file

# ------------
#  theme
# ------------

LAIN_THEME_PATH="$LAIN/themes/powerlevel10k/powerlevel10k.zsh-theme"

# 检查主题是否存在
if [[ -f "$LAIN_THEME_PATH" ]]; then
  source "$LAIN_THEME_PATH"
else
  echo "未找到: $LAIN_THEME_PATH" >&2
fi

# 设置补全颜色为与 `ls` 命令一致，在主题加载之后
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

