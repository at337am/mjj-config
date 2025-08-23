#!/usr/bin/env bash

# Session name
SESSION_NAME="nekoray"

# Check if the session exists
if tmux has-session -t $SESSION_NAME 2>/dev/null; then
    echo "Session $SESSION_NAME already exists. Killing the session..."
    # Kill the session
    tmux kill-session -t $SESSION_NAME
fi

# Create a new tmux session and run nekoray
tmux new-session -d -s $SESSION_NAME '/opt/soft/nekoray/nekoray'

# Detach from the tmux session
tmux detach -s $SESSION_NAME

# Exit the terminal
exit

