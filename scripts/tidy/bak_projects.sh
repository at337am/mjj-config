#!/usr/bin/env bash

bak_dir="/data/bak/projects"

mkdir -p "$bak_dir"

bak_notes() {
    rsync -avh \
        --delete \
        --delete-excluded \
        --exclude='.git' \
        --exclude='.gitignore' \
        --exclude='.obsidian' \
        "$HOME/Documents/notes/" \
        "$bak_dir/notes/"
}

bak_memos() {
    rsync -avh \
        --delete \
        --delete-excluded \
        --exclude='.git' \
        "$HOME/Documents/memos/" \
        "$bak_dir/memos/"
}

bak_dev() {
    rsync -avh \
        --delete \
        --delete-excluded \
        --exclude='*/.git' \
        "$HOME/workspace/dev/" \
        "$bak_dir/dev/"
}

bak_notes
bak_memos
bak_dev

printf "✅ projects 备份完成\n"
