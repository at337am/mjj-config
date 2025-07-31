# 定义回收站目录的绝对路径, 用于存放被删除文件的临时位置
TRASH_DIR="/data/.trash"

# ------------
#  rm
# ------------

# 用于替代系统默认的 rm 命令, 实现“回收站式删除”
# --- 1 个或以上参数 ---
rm() {
  # 若未提供任何参数, 则提示用户用法并退出
  if [ $# -eq 0 ]; then
    printf "rm: Nothing to delete, buddy.\n" >&2
    printf "Usage: rm <path>...\n" >&2
    return 1
  fi

  # 创建回收站目录（若不存在）, 并确保其可写
  mkdir -p "$TRASH_DIR"
  if [ ! -d "$TRASH_DIR" ] || [ ! -w "$TRASH_DIR" ]; then
    printf "Error: Uh-oh! Can't access your trash can at '%s'.\n" "$TRASH_DIR" >&2
    printf "Check if you can write to '%s'.\n" "$(dirname "$TRASH_DIR")" >&2
    return 1
  fi

  local move_failed=0  # 初始化失败标志, 用于记录是否有移动操作失败
  local item

  # 遍历所有待删除的参数, 逐一处理
  for item in "$@"; do
    # 若指定路径不存在且不是符号链接, 则跳过并报错
    if [ ! -e "$item" ] && [ ! -L "$item" ]; then
      printf "Error: Can't find '%s' — already gone?\n" "$item" >&2
      move_failed=1
      continue
    fi

    # 生成带时间戳的目标文件名, 避免重复并保留原始文件名信息
    local base_name=$(basename -- "$item")
    local destination_path="${TRASH_DIR}/$(date +%y%m%d_%H%M%S_%N)_${base_name}"

    # 检查生成的路径是否与现有文件冲突, 若冲突则附加随机后缀以保证唯一性
    if [ -e "$destination_path" ] || [ -L "$destination_path" ]; then
      destination_path+=".$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 6)"
    fi

    # 显示移动操作的信息, 便于用户追踪
    printf "Moving to trash: %s -> %s\n" "$item" "$(basename -- "$destination_path")"

    # 执行移动操作, 将目标文件/目录移动至回收站目录
    # 使用 '--' 明确后续为路径参数, 防止误解析为选项
    if ! mv -- "$item" "$destination_path"; then
      printf "Error: Failed to move '%s' to '%s'.\n" "$item" "$destination_path" >&2
      move_failed=1
    fi
  done

  # 根据是否存在失败的移动操作决定函数返回值
  return $move_failed
}

# ------------
#  cl_trash
# ------------

# 用于清空自定义回收站目录中的所有内容
# --- 无参数 ---
cl_trash() {
  # 若回收站目录存在且为空, 则提示用户并结束函数
  if [[ -d "$TRASH_DIR" && -z "$(find "$TRASH_DIR" -mindepth 1 -print -quit)" ]]; then
    printf "Trash bin’s already sparkling clean!\n"
    return 0
  fi

  # 强制并递归删除回收站目录中的所有文件和隐藏文件
  # command 表示调用系统原始的 rm 命令
  # 使用通配符 *(D) 以确保包含隐藏项（如以.开头的文件）
  command rm -rfv -- "${TRASH_DIR}/"*(D)
}

# ------------
#  d
# ------------

# --- 无参数 ---
d () {
  if [[ -n "$1" ]]; then
    dirs "$@"
  else
    dirs -v | head -n 10
  fi
}
compdef _dirs d

# ------------
#  mkcd
# ------------

# 创建一个新目录, 并进入该目录
# 若新目录已存在, 则不执行
# --- 1 个参数 ---
mkcd() {
  # 如果未提供目录名称参数, 则提示错误并退出
  if [[ -z "$1" ]]; then
    printf "mkcd: Nothing to create, buddy.\n" >&2
    printf "Usage: mkcd <dir-name>\n" >&2
    return 1
  fi

  # 判断目标目录是否已存在, 若存在则报错并退出
  if [[ -e "$1" ]]; then
    printf "Error: Target '%s' already exists.\n" "$1" >&2
    return 1
  fi

  # 创建指定目录（若不存在则自动递归创建）, 成功后立即进入该目录
  mkdir -p -- "$1" && cd -- "$1"
}

# ------------
#  mkmv
# ------------

# 创建一个新目录, 并将一个或多个指定文件或目录移动到该目录中
# 若新目录已存在, 则不执行
# --- 2 个或以上参数 ---
mkmv() {
  # 检查传入参数数量是否不少于两个, 若不足则提示错误并退出
  if [[ $# -lt 2 ]]; then
    printf "mkmv: Oops! At least two arguments are required.\n" >&2
    printf "Usage: mkmv <path>... <new-dir>\n" >&2
    return 1
  fi

  # 将最后一个参数视为目标目录名称
  local new_dir="${@[-1]}"

  # 除最后一个参数外, 其余均视为需要移动的源文件或目录路径列表
  local paths=("${(@)@[1,-2]}")

  # 判断目标目录是否已存在, 若存在则报错并退出
  if [[ -e "$new_dir" ]]; then
    printf "Error: Target '%s' already exists.\n" "$new_dir" >&2
    return 1
  fi

  local p

  # 逐个检查所有源路径是否存在, 若有任意不存在则立即停止并提示错误
  for p in "${paths[@]}"; do
    if [[ ! -e "$p" ]]; then
      printf "Error: Source '%s' does not exist.\n" "$p" >&2
      return 1
    fi
  done

  # 创建目标目录（支持递归创建）, 并将所有源文件/目录移动到该目录中
  # 成功时打印操作结果, 否则提示失败原因（如权限不足）
  if mkdir -p "$new_dir" && mv -- "${paths[@]}" "$new_dir/"; then
    printf "Created %s/ and moved %d item(s) inside.\n" "$new_dir" "${#paths[@]}"
    return 0
  else
    printf "Error: Failed to create directory or move items. Check permissions.\n" >&2
    return 1
  fi
}

# ------------
#  bak
# ------------

# 备份一个或多个文件
# 输出在源文件所处的目录
# --- 1 个或以上参数 ---
bak() {
  # 检查是否提供了至少一个参数, 若无则输出错误提示并退出
  if [[ $# -eq 0 ]]; then
    printf "bak: Nothing to back up, buddy.\n" >&2
    printf "Usage: bak <file>...\n" >&2
    return 1
  fi

  # 初始化状态标志变量, 用于记录是否有备份失败的情况
  local bak_failed=0

  local file

  # 遍历所有传入的文件参数, 逐个进行备份操作
  for file in "$@"; do
    # 判断当前参数是否为常规文件, 非文件或不存在时跳过并标记错误
    if [[ ! -f "$file" ]]; then
      printf "Error: File '%s' not found or is not a regular file. Skipping.\n" "$file" >&2
      bak_failed=1
      continue
    fi

    # 生成备份文件名, 附加精确到纳秒的时间戳, 避免文件名冲突
    local backup_file="${file}_$(date +%y%m%d_%H%M%S_%N).bak"

    # 检测备份文件名是否已存在, 若存在则添加随机后缀确保唯一性
    if [ -e "$backup_file" ] || [ -L "$backup_file" ]; then
      backup_file+=".$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 6)"
    fi

    # 复制原文件到备份文件, 成功则打印提示, 失败则记录错误
    if cp -- "$file" "$backup_file"; then
      printf "Backed up -> %s\n" "$backup_file"
    else
      printf "Error: Failed to create backup for '%s'.\n" "$file" >&2
      bak_failed=1
    fi
  done

  # 函数返回整体备份操作状态, 0 表示全部成功, 非零表示至少有失败
  return "$bak_failed"
}

# ------------
#  pack
# ------------

# 打包一个或多个文件/目录
# 默认为 .tar | 支持 -z 选项: tar.gz
# 如果目标归档文件已存在, 则跳过该项以防止覆盖
# 输出在当前路径下
# --- 1 个或以上位置参数, (可选) 1 个选项参数 ---
pack() {
  # 默认不使用 gzip 压缩
  local use_gzip=0
  local tar_options="-cf"
  local extension=".tar"

  # 检查并处理 -z 或 --gzip 选项
  # 检查第一个参数是否是我们的压缩标志
  if [[ "$1" == "-z" || "$1" == "--gzip" ]]; then
    use_gzip=1
    tar_options="-czf"
    extension=".tar.gz"
    shift  # 关键步骤: 移除该参数, 以便 "$@" 只包含要打包的参数
  fi

  # 检查是否提供至少一个要打包的参数
  if [[ $# -eq 0 ]]; then
    printf "pack: Nothing to pack, buddy.\n" >&2
    printf "Usage: pack [-z|--gzip] <path>...\n" >&2 # 更新用法提示
    return 1
  fi

  local pack_failed=0
  local item

  # 逐个处理每个待打包的文件或目录
  for item in "$@"; do
    # 确认当前待打包项存在, 若不存在则记录错误并跳过
    if [[ ! -e "$item" ]]; then
      printf "Error: Oops! Can't find '%s' anywhere.\n" "$item" >&2
      pack_failed=1
      continue
    fi

    # 动态生成目标归档文件名
    # 使用之前设置的变量来生成文件名, 可能是 .tar 或 .tar.gz
    local archive_name="$(basename -- "$item")${extension}"

    # 检查归档文件是否已存在, 若存在则避免覆盖, 跳过此项并记录错误
    if [[ -e "$archive_name" ]]; then
      printf "Error: Whoa! '%s' already exists. No double trouble!\n" "${archive_name}" >&2
      pack_failed=1
      continue
    fi

    # 动态执行 tar 命令
    # 使用之前设置的变量来执行 tar, 可能是 -cf 或 -czf
    # 注意: ${tar_options} 不加引号, 以便 shell 将 "-czf" 解释为选项, 而不是单个文件名
    if tar ${tar_options} "${archive_name}" -- "$item"; then
      printf "Packed -> %s\n" "${archive_name}"
    else
      printf "Error: Packing failed for '%s'.\n" "$item" >&2
      pack_failed=1
    fi
  done

  # 所有打包操作完成后, 返回总体状态, 0 表示全部成功, 非0表示至少有失败
  return "$pack_failed"
}

# ------------
#  byebye
# ------------

# 执行关闭程序的脚本后, 启动倒计时并最终关机
# --- 无参数 ---
byebye() {
  # 预定义关闭程序的脚本路径
  local script_path="$HOME/workspace/dev/mjj-config/scripts/kill_apps.sh"
  # 设定倒计时持续秒数
  local countdown=3

  # 检查关闭程序脚本是否存在, 缺失则报错并退出
  if [[ ! -f "$script_path" ]]; then
    printf "Error: Oops! Can't find kill script: %s\n" "$script_path" >&2
    return 1
  fi

  # 提示用户程序即将关闭
  printf "Time to bid farewell to running apps...\n"

  # 执行关闭程序的脚本
  sh "$script_path"

  # 脚本执行完成后, 通知用户所有程序已关闭
  printf "All clear! Apps have left the building.\n"
  # 通知用户倒计时开始, 并提示可通过 Ctrl+C 取消关机
  printf "Going dark in %d seconds. Press Ctrl+C to stay alive.\n" "$countdown"

  local i

  # 逐秒倒计时显示剩余时间, 允许用户中断操作
  for i in $(seq "$countdown" -1 1); do
    printf "\rT-minus %d seconds... Ctrl+C to cancel." "$i"
    sleep 1
  done

  # 倒计时结束后打印关机提示信息
  printf "\nLights out! Dream of code and bugs.\n"

  # 使用 sudo 权限执行系统关机命令, 立即关闭系统电源
  sudo shutdown -h now
}
