#!/usr/bin/env bash

session_name="nekoray"

# Check if the session exists
if tmux has-session -t $session_name 2>/dev/null; then
    printf "Session %s already exists. Killing the session...\n" "$session_name"
    # Kill the session
    tmux kill-session -t $session_name
fi

# Create a new tmux session and run nekoray
tmux new-session -d -s $session_name '/opt/soft/nekoray/nekoray'

# Detach from the tmux session
tmux detach -s $session_name

exit 0
