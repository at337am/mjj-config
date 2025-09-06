#!/usr/bin/env bash

mkdir -p "/data/bak/restore/projects"

bak_notes() {
    rsync -avh \
        --delete \
        --delete-excluded \
        --exclude='.git' \
        --exclude='.gitignore' \
        --exclude='.obsidian' \
        "$HOME/Documents/notes/" \
        "/data/bak/restore/projects/notes/"
}

bak_memos() {
    rsync -avh \
        --delete \
        --delete-excluded \
        --exclude='.git' \
        "$HOME/Documents/memos/" \
        "/data/bak/restore/projects/memos/"
}

bak_dev() {
    rsync -avh \
        --delete \
        --delete-excluded \
        --exclude='*/.git' \
        "$HOME/workspace/dev/" \
        "/data/bak/restore/projects/dev/"
}

bak_notes
bak_memos
bak_dev

printf "✅ projects 备份完成\n"
