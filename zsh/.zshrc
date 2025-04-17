# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="ys"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# --- 自定义 rm 函数：移动文件到回收站 (运行时检查并创建回收站目录) ---

# 定义 rm 函数，覆盖系统默认的 rm
rm() {
  local TRASH_DIR="/data/.trash"

  # 检查调用 rm 时是否提供了参数（文件名）
  if [ $# -eq 0 ]; then
    echo "rm: 缺少操作对象" >&2
    echo "请尝试执行 'rm --help' 来获取更多信息。" >&2
    return 1 # 返回失败状态码
  fi

  # 1. 尝试创建回收站目录 (-p 选项表示如果父目录不存在也尝试创建，且目录已存在时不报错)
  #    我们不在这里预先检查权限，直接让 mkdir 尝试。
  #    如果 mkdir 因为权限不足等原因失败，它可能会输出错误信息到 stderr。
  mkdir -p "$TRASH_DIR"

  # 2. 检查 mkdir 的尝试结果：回收站目录现在是否存在并且可写？
  #    这是关键一步，无论目录是之前就存在，还是刚刚创建成功，都需要通过这个检查。
  if [ ! -d "$TRASH_DIR" ] || [ ! -w "$TRASH_DIR" ]; then
    # 如果目录不存在或不可写（意味着 mkdir 创建失败或目录权限有问题）
    echo "rm: 错误：无法创建或访问回收站目录 '$TRASH_DIR'。" >&2
    echo "请检查您是否拥有在 '$(dirname "$TRASH_DIR")' 目录下创建目录以及写入 '$TRASH_DIR' 的权限。" >&2
    # dirname "$TRASH_DIR" 会得到 /data
    return 1 # 中止执行，因为无法将文件移入回收站
  fi
  # --- 回收站目录检查/创建逻辑结束 ---

  # 声明函数内部使用的局部变量
  local item
  local timestamp
  local base_name
  local unique_name
  local destination_path
  local move_failed=0 # 标记是否有移动操作失败

  # 遍历所有要删除的文件/目录参数
  for item in "$@"; do
    # 检查项目是否存在
    if [ ! -e "$item" ] && [ ! -L "$item" ]; then
      echo "rm: 无法移除 '$item': 没有那个文件或目录" >&2
      move_failed=1
      continue
    fi

    # 生成唯一的、带时间戳的文件名
    timestamp=$(date +%Y%m%d_%H%M%S_%N)
    base_name=$(basename -- "$item")
    unique_name="${timestamp}_${base_name}"
    destination_path="${TRASH_DIR}/${unique_name}"

    # 打印提示信息
    echo "移动 '$item' 到回收站，新文件名为 '$unique_name' (位于 $TRASH_DIR)"

    # 执行移动命令
    command mv -- "$item" "$destination_path"

    # 检查 mv 命令是否成功
    if [ $? -ne 0 ]; then
      echo "rm: 移动 '$item' 到 '$destination_path' 失败" >&2
      move_failed=1
      # continue # 即使失败，也继续处理下一个文件
    fi
  done

  # 返回最终状态 (0 代表全部成功，1 代表至少有一个文件处理失败)
  return $move_failed
}

# --- 自定义 rm 函数结束 ---

