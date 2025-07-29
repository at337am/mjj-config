# 定义回收站目录的路径
TRASH_DIR="/data/.trash"

# rm 函数, 为了覆盖默认的 rm 命令
rm() {
  # 检查调用 rm 时是否提供了参数（文件名）
  if [ $# -eq 0 ]; then
    printf "rm: Nothing to delete, buddy.\n" >&2
    printf "Usage: rm <file-or-dir>...\n" >&2
    return 1
  fi

  # 确保回收站目录存在且可写
  mkdir -p "$TRASH_DIR"
  if [ ! -d "$TRASH_DIR" ] || [ ! -w "$TRASH_DIR" ]; then
    printf "Error: Uh-oh! Can't access your trash can at '%s'.\n" "$TRASH_DIR" >&2
    printf "Check if you can write to '%s'.\n" "$(dirname "$TRASH_DIR")" >&2
    return 1
  fi

  # 声明函数内部使用的局部变量
  local item
  local base_name
  local template
  local destination_path
  local unique_name
  local move_failed=0 # 标记是否有移动操作失败

  # 遍历所有要删除的文件/目录参数
  for item in "$@"; do
    # 检查项目是否存在
    if [ ! -e "$item" ] && [ ! -L "$item" ]; then
      printf "Error: Can't find '%s' — already gone?\n" "$item" >&2
      move_failed=1
      continue
    fi

    # --- 关键部分：使用 mktemp 生成唯一的目标路径 ---
    base_name=$(basename -- "$item")
    template="${TRASH_DIR}/$(date +%y%m%d_%H%M%S)_XXXXXXXXXX_${base_name}"

    # 使用 mktemp -u 生成一个唯一的路径名, 但不实际创建文件
    destination_path=$(mktemp -u "$template")

    if [ -z "$destination_path" ]; then
      printf "Error: Failed to create a unique trash name for '%s'.\n" "$item" >&2
      move_failed=1
      continue
    fi

    # 从完整路径中提取唯一的文件名部分, 用于友好提示
    unique_name=$(basename -- "$destination_path")
    printf "Moving to trash: %s -> %s\n" "$item" "$unique_name"

    # 执行移动命令
    # -- 是 GNU 命令中的一个惯用法, 表示“后续参数均为文件名而非选项”
    if ! command mv -- "$item" "$destination_path"; then
      printf "Error: Failed to move '%s' to '%s'.\n" "$item" "$destination_path" >&2
      move_failed=1
    fi
  done

  # 返回最终状态 (0 代表全部成功, 1 代表至少有一个文件处理失败)
  return $move_failed
}

# cl_trash 函数, 清空回收站
cl_trash() {
  if [[ -d "$TRASH_DIR" && -z "$(find "$TRASH_DIR" -mindepth 1 -print -quit)" ]]; then
    printf "Trash bin’s already sparkling clean!\n"
    return 0
  fi

  command rm -rfv -- "${TRASH_DIR}/"*(D)
}

# d 函数
d () {
  if [[ -n "$1" ]]; then
    dirs "$@"
  else
    dirs -v | head -n 10
  fi
}
compdef _dirs d

# mkcd 函数, 创建目录并立即进入
mkcd() {
  if [[ -z "$1" ]]; then
    echo "Usage: mkcd <dir-name>" >&2
    return 1
  fi

  mkdir -p -- "$1" && cd -- "$1"
}

# bak 函数, 创建一个带精简时间戳的文件备份
# 输出在相同路径下, 因为它的目的是为了备份, 所以肯定是要放在相同路径下的
bak() {
  if [[ -z "$1" ]]; then
    echo "Usage: bak <file>" >&2
    return 1
  fi

  # 确保文件存在
  if [[ ! -f "$1" ]]; then
      echo "Error: File '$1' not found or is not a regular file." >&2
      return 1
  fi

  local backup_file="${1}_$(date +%y%m%d_%H%M%S).bak"

  # 执行复制并判断是否成功
  if command cp -- "$1" "$backup_file"; then
    echo "Backup created -> $backup_file"
  else
    echo "Error: Failed to create backup." >&2
    return 1
  fi
}

# pack 函数, 将文件或目录打包成 .tar 文件 (已存在则不覆盖)
# 输出在命令执行的路径下
pack() {
  if [[ -z "$1" ]]; then
    printf "pack: Hey! Gimme a file or folder to pack.\n" >&2
    printf "Usage: pack <file-or-dir>\n" >&2
    return 1
  fi

  # 确保目标存在
  if [[ ! -e "$1" ]]; then
    printf "Error: Oops! Can't find '%s' anywhere.\n" "$1" >&2
    return 1
  fi

  # basename 也应该使用 --
  local archive_name="$(basename -- "$1").tar"

  # 使用 -- 来保护检查
  if [[ -e "$archive_name" ]]; then
    printf "Error: Whoa! '%s' already exists. No double trouble!\n" "${archive_name}" >&2
    return 1
  fi

  printf "Packing now...\n"

  if tar -cf "${archive_name}" -- "$1"; then
      printf "Successfully packed -> %s\n" "${archive_name}"
  else
      printf "Error: Packing failed.\n" >&2
      return 1
  fi
}

# byebye 函数
byebye() {
  local script_path="$HOME/workspace/dev/mjj-config/scripts/kill_apps.sh"
  local countdown=3  # 倒计时时间 (秒)

  # 检查脚本是否存在
  if [[ ! -f "$script_path" ]]; then
    printf "Error: Oops! Can't find kill script: %s\n" "$script_path" >&2
    return 1
  fi

  printf "Time to bid farewell to running apps...\n"

  sh "$script_path"

  printf "All clear! Apps have left the building.\n"
  printf "Going dark in %d seconds. Press Ctrl+C to stay alive.\n" "$countdown"

  # 倒计时结束后, 执行关机
  for i in $(seq "$countdown" -1 1); do
    printf "\rT-minus %d seconds... Ctrl+C to cancel." "$i"
    sleep 1
  done

  printf "\nLights out! Dream of code and bugs.\n"

  # 最后, 执行关机
  sudo shutdown -h now
}
