# 自定义 rm 函数，覆盖系统默认的 rm
rm() {
  local TRASH_DIR="/data/.trash"

  # 检查调用 rm 时是否提供了参数（文件名）
  if [ $# -eq 0 ]; then
    echo "rm: 缺少操作对象" >&2
    echo "用法: rm <filename>" >&2
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


# d 函数
d () {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -n 10
  fi
}
compdef _dirs d


# 未找到命令时显示图像
# command_not_found_handler() {
#   local RESET="\e[0m"
#   local GRAY="\e[90m"
#   local PINK="\e[95m"
#   local RED="\e[31m"
#   local BOLD="\e[1m"

#   printf "${GRAY} /\\_/\\ ${RESET}\n" >&2
#   printf "${GRAY}( ${PINK}o.o${GRAY} )${RESET}  <-- ${RED}${BOLD}Oops! Command not found: ${BOLD}%s${RESET}\n" "$1" >&2
#   printf "${GRAY} > ^ < ${RESET}\n" >&2

#   return 127
# }

