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


#============================
# LINTING ALIAS
#============================

# Smart lint command that detects project type
lint() {
    # Check for Node.js/React project
    if [ -f "package.json" ]; then
        echo "📦 Node.js project detected"

        # Check if npm run lint exists
        if grep -q '"lint"' package.json 2>/dev/null; then
            echo "Running: npm run lint"
            npm run lint
        elif command -v eslint &> /dev/null; then
            echo "Running: eslint ."
            eslint .
        else
            echo "❌ No linting configured. Install ESLint with:"
            echo "   npm install --save-dev eslint"
            echo "   npx eslint --init"
            return 1
        fi

    # Check for Python project
    elif [ -f "pyproject.toml" ] || [ -f "setup.py" ] || [ -f "requirements.txt" ] || ls *.py &>/dev/null; then
        echo "🐍 Python project detected"

        # Try ruff first (modern and fast)
        if command -v ruff &> /dev/null; then
            echo "Running: ruff check ."
            ruff check .
        # Fall back to flake8
        elif command -v flake8 &> /dev/null; then
            echo "Running: flake8 ."
            flake8 .
        else
            echo "❌ No Python linter found. Install ruff with:"
            echo "   uv pip install ruff"
            echo "Or install flake8 with:"
            echo "   uv pip install flake8"
            return 1
        fi

    else
        echo "❓ Could not detect project type (no package.json or Python files)"
        return 1
    fi
}

# Format command for Python (using ruff or black)
fmt() {
    if [ -f "pyproject.toml" ] || [ -f "setup.py" ] || [ -f "requirements.txt" ] || ls *.py &>/dev/null; then
        echo "🐍 Python project detected"

        # Try ruff format first
        if command -v ruff &> /dev/null; then
            echo "Running: ruff format ."
            ruff format .
        # Fall back to black
        elif command -v black &> /dev/null; then
            echo "Running: black ."
            black .
        else
            echo "❌ No Python formatter found. Install ruff with:"
            echo "   uv pip install ruff"
            return 1
        fi
    elif [ -f "package.json" ]; then
        echo "📦 Node.js project detected"

        if grep -q '"format"' package.json 2>/dev/null; then
            echo "Running: npm run format"
            npm run format
        elif command -v prettier &> /dev/null; then
            echo "Running: prettier --write ."
            prettier --write .
        else
            echo "❌ No formatter configured"
            return 1
        fi
    else
        echo "❓ Could not detect project type"
        return 1
    fi
}

# Alias for common linting tasks
alias lintfix='lint --fix 2>/dev/null || ruff check --fix . 2>/dev/null'


#============================
# MODERN TOOLS ALIAS
#============================

# eza - better ls (overrides previous ls aliases)
if command -v eza &> /dev/null; then
    alias ls='eza --group-directories-first --icons'
    alias l='eza -lh --group-directories-first --icons'
    alias ll='eza -lha --group-directories-first --icons'
    alias la='eza -lha --group-directories-first --icons'
    alias lt='eza -lh --sort=modified --reverse --icons'
    alias lsize='eza -lh --sort=size --reverse --icons'
    alias tree='eza --tree --icons'
    alias ltree='eza --tree --level=2 --icons'
fi


#============================
# NOTIFICATION FUNCTIONS
#============================

# Terminal notification with bell and visual feedback
notify() {
    local title="$1"
    local message="$2"
    echo -e "\a"  # Terminal bell
    echo -e "\n🔔 $title: $message\n"
}

# Notify when task completes successfully
notify-done() {
    local message="${1:-Task completed}"
    echo -e "\a"
    echo -e "\n✓ Done: $message\n"
}

# Notify when error occurs
notify-error() {
    local message="${1:-An error occurred}"
    echo -e "\a"
    echo -e "\n✗ Error: $message\n"
}

# Notify when action required
notify-action() {
    local message="${1:-Action required}"
    echo -e "\a"
    echo -e "\n⚠ Action Required: $message\n"
}

# Run command and notify on completion (success or failure)
run-notify() {
    local start_time=$(date +%s)
    local cmd="$*"

    if "$@"; then
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        notify-done "Completed in ${duration}s: $cmd"
        return 0
    else
        local exit_code=$?
        notify-error "Failed (exit $exit_code): $cmd"
        return $exit_code
    fi
}

# Notify when long-running command finishes (use with &&)
alias notify-me='notify-done "Command finished"'
