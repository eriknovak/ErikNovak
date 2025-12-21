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
# list all with human-readable sizes
alias la='ls -lAh --color=always --group-directories-first'
# sort by time (newest first)
alias lt='ls -lth --color=always'
# sort by size (largest first)
alias lsize='ls -lSh --color=always'


#============================
# NAVIGATION ALIAS
#============================

# quick directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'


#============================
# GREP ALIAS
#============================

# give color to grep and redirect it to egrep
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias grep='grep --colour=auto'


#============================
# GIT ALIAS
#============================

# git shortcuts
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -v'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gds='git diff --staged'
alias glog='git log --oneline --graph --decorate --all -20'
alias glg='git lg'
alias gbr='git branch -v'
alias gco='git checkout'


#============================
# PYTHON/UV ALIAS
#============================

# python shortcuts
alias py='python3'
alias python='python3'
# uv virtual environment shortcuts
alias venv='uv venv'
alias va='source .venv/bin/activate'
alias vd='deactivate'
# uv pip shortcuts
alias pi='uv pip install'
alias pr='uv pip install -r requirements.txt'
alias pf='uv pip freeze'
alias pl='uv pip list'


#============================
# SYSTEM ALIAS
#============================

# safe operations (ask before overwriting)
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# show directory/disk size
alias du='du -h --max-depth=1'
alias df='df -h'

# process management
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'

# quick file search
alias ff='find . -type f -name'
alias fd='find . -type d -name'

# show PATH in readable format
alias path='echo $PATH | tr ":" "\n"'
