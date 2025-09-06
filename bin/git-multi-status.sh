#!/usr/bin/env bash

PROJECT_PATHS=(
    "$HOME/Documents/notes"
    "$HOME/workspace/dev/mjj-config"
    "$HOME/workspace/dev/skit"
    "$HOME/workspace/dev/raindrop"
    "$HOME/Documents/memos"
)

C_BLUE="\033[0;34m"
C_GREEN="\033[0;32m"
C_YELLOW="\033[0;33m"
C_RED="\033[0;31m"
C_RESET="\033[0m"

for dir in "${PROJECT_PATHS[@]}"; do
    # printf "${C_BLUE}▪ Checking: %s${C_RESET}\n" "$dir"
    printf "${C_BLUE}▪ Checking: %s${C_RESET}\n" "${dir##*/}"

    # 检查 .git 目录是否存在, 这是判断是否为 git 仓库的最可靠方法
    if [[ ! -d "$dir/.git" ]]; then
        printf "  ${C_RED}Error: Not a git repository or directory does not exist${C_RESET}\n\n"
        continue # 继续检查下一个项目
    fi

    (
        cd "$dir" || exit 1

        status=$(git status --short)

        if [[ -z "$status" ]]; then
            # 如果输出为空, 说明工作区是干净的
            printf "  ${C_GREEN}✔ Clean${C_RESET}\n\n"
        else
            # 如果有输出, 说明有变更
            printf "  ${C_YELLOW}Changes detected:${C_RESET}\n"
            # 使用 sed 给每一行前面加上缩进, 使输出更整齐
            echo "$status" | sed 's/^/   /'
            printf "\n"
        fi
    )
done

printf "All checks complete\n"
