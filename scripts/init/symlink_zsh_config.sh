command rm -rf ~/.p10k.zsh && \
command rm -rf ~/.zshrc && \
command rm -rf ~/.zsh_history && \
command rm -rf ~/.zcompdump && \
command rm -rf ~/.lain && \
command rm -rf ~/.cache/p10k*

rsync -avh ~/workspace/dev/mjj-config/zsh/ ~/

(cd ~/.lain/themes && \
tar -zxf powerlevel10k.tar.gz && \
command rm -f powerlevel10k.tar.gz)

chmod 600 ~/.zshrc &&; \
chmod 600 ~/.zprofile; \
chmod 600 ~/.p10k.zsh

command rm -rf ~/.lain/lib/aliases.zsh && \
ln -s ~/workspace/dev/mjj-config/zsh/.lain/lib/aliases.zsh ~/.lain/lib/aliases.zsh

chsh -s /usr/bin/zsh
