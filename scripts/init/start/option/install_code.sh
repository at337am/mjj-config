#!/usr/bin/env bash

set -euo pipefail

log() {
    printf '\n-=> %s <=-\n' "$1"
}

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" \
    | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

sudo dnf check-update

sudo dnf -y install code
