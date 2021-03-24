#!/bin/bash

#============================
# TMUX ALIAS
#============================

# open tmux with 256 colors
alias tmux='tmux -2'
alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'


#============================
# LS ALIAS
#============================

# make ll human readable and show directories first
alias ls='ls --color=always --group-directories-first'
# list non-hidden files
alias l='ls -lh --sort=extension --group-directories-first'
# list all files
alias ll='l -a --ignore={.,..}'
# list only hidden files
alias lh='l -a --ignore={[!.]*,.,..}'
# sort ll by file size
alias lls='ll -S'
# sort ll by modification time
alias llt='ll -t'


#============================
# GREP ALIAS
#============================

# give color to grep and redirect it to egrep
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias grep='grep --colour=auto'
