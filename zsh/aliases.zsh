# misc
alias cl='clear'
alias vim='nvim'
alias del='/bin/rm'
alias cl_trash='/bin/rm -rfv /data/.trash/*'
alias px='http_proxy=http://127.0.0.1:2080 https_proxy=http://127.0.0.1:2080'
alias ryc='rsync -avh --progress --ignore-existing'
alias run_nekoray='/usr/local/nekoray/run_nekoray.sh'
alias uvdev='source /opt/venvs/dev/bin/activate'

# docker
alias dstopall='sudo docker stop $(sudo docker ps -q)'
alias dstartall='sudo docker start $(sudo docker ps -qa)'
alias dstop='sudo docker stop'
alias dstart='sudo docker start'
alias dcup='sudo docker compose up -d'
alias dis='sudo docker images'
alias dps='sudo docker ps'
alias dec='sudo docker exec -it'
alias drm='sudo docker rm'
alias drmi='sudo docker rmi'
alias dvp='sudo docker volume prune'
alias dlg='sudo docker logs'

# systemctl
alias s_status='sudo systemctl status'
alias s_restart='sudo systemctl restart'
alias s_stop='sudo systemctl stop'
alias s_start='sudo systemctl start'
alias s_enable='sudo systemctl enable'

# tmux
alias tls='tmux ls'
alias tn='tmux new'
alias tns='tmux new -s'
alias ta='tmux attach'
alias tat='tmux attach -t'
alias tks='tmux kill-session -t'
alias tksall='tmux kill-server'

