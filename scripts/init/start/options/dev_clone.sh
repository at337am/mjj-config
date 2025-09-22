#!/usr/bin/env bash

set -euo pipefail

log() {
    printf '\n-=> %s <=-\n' "$1"
}

log "开始克隆所有项目到 dev"

command rm -rf ~/workspace/dev/mjj-config

git clone git@github.com:at337am/mjj-config.git ~/workspace/dev/mjj-config

git clone git@github.com:at337am/notes.git ~/workspace/dev/notes

git clone git@github.com:at337am/skit.git ~/workspace/dev/skit

git clone git@github.com:at337am/raindrop.git ~/workspace/dev/raindrop

log "dev 项目克隆完毕"
