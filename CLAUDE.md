# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for a data scientist's development environment configuration. The repository contains configuration files and setup scripts for bash, tmux, vim, nano, starship prompt, and git.

## Setup and Installation

### Primary Setup Command
```bash
./setup.sh
```

This is the main script that installs all configurations by creating symlinks from the home directory to the dotfiles in this repository. The script:
- Checks for tmux installation and installs TPM (Tmux Plugin Manager)
- Installs Starship prompt if not present
- Installs nvm (Node Version Manager) if not present
- Installs modern terminal tools (zoxide, bat, eza, lazygit, tmuxinator)
- Installs Catppuccin vim theme
- Creates necessary directories (nano backups, ~/.config)
- Creates symlinks for all configuration files
- Prompts for Git user configuration (creates ~/.gitconfig.local)

### After Setup
```bash
source ~/.bashrc  # or restart terminal
```

For tmux setup:
1. Start tmux: `tmux`
2. Install plugins: Press `Ctrl+b` then `Shift+I`

## Key Components

### Shell Configuration (.dotfiles/bash/)
- `.bashrc` - Main bash configuration with Starship prompt and nvm setup
- `.bash_aliases` - Comprehensive aliases for tmux, git, python/uv, navigation, and system operations
- `.bash_profile` - Simple profile that sources .bashrc

### Terminal Multiplexer (.dotfiles/tmux/)
- `.tmux.conf` - Tmux configuration with Catppuccin theme and vim-style bindings
- Custom key bindings: `prefix + |` (horizontal split), `prefix + -` (vertical split)
- Vim-style navigation: `prefix + h/j/k/l`
- See `.dotfiles/tmux/README.md` for detailed plugin and key binding information

### Editors
- `.dotfiles/vim/` - Vim configuration with Catppuccin theme and pathogen plugin manager
- `.dotfiles/.nanorc` - Nano configuration with syntax highlighting

### Prompt (.dotfiles/starship/)
- `starship.toml` - Starship prompt configuration with Catppuccin Mocha theme

### Version Control
- `.dotfiles/.gitconfig` - Git configuration with useful aliases (`lg`, `st`, `up`) and colorization
- Includes `~/.gitconfig.local` for user-specific settings

## Development Tools and Aliases

### Python/UV Shortcuts
- `py`, `python` - python3
- `venv` - uv venv
- `va` - source .venv/bin/activate
- `vd` - deactivate
- `pi` - uv pip install
- `pr` - uv pip install -r requirements.txt

### Git Shortcuts
- `g` - git
- `gs` - git status -sb
- `glog` - git log --oneline --graph --decorate --all -20
- `glg` - git lg (custom alias from .gitconfig)

### Tmux Shortcuts
- `ta` - tmux attach -t
- `ts` - tmux new-session -s
- `tl` - tmux list-sessions

### Navigation
- `..`, `...`, `....`, `.....` - Quick directory traversal
- Enhanced `ls` variants with colors and directory grouping

### Modern Terminal Tools
- **bat** - Syntax-highlighted file viewer (replaces `cat`)
  - `cat` - bat without paging
  - `catt` - bat with paging
  - `catp` - bat without decorations
- **eza** - Modern ls replacement with icons and git integration
  - `ls` - basic listing with icons
  - `l`, `ll`, `la` - various detailed listings
  - `tree` - tree view
  - `ltree` - tree view (2 levels)
- **zoxide** - Smart directory jumper (learns from usage)
  - `cd` - aliased to `z` (smart jump)
  - `cdi` - interactive directory selection
- **lazygit** - Terminal UI for git
  - `lg` - launch lazygit
- **tmuxinator** - Tmux session manager
  - `mux` - tmuxinator command
  - `muxs` - start session
  - `muxn` - create new session
  - `muxl` - list sessions

### Notification System
Terminal notifications with bell and visual feedback:
- `notify-done "message"` - Success notification
- `notify-error "message"` - Error notification
- `notify-action "message"` - Action required notification
- `notify "title" "message"` - Generic notification
- `run-notify command args` - Run command and notify on completion
- `command && notify-me` - Notify when command finishes
- Perfect for long-running tasks, builds, tests, model training

## Architecture Notes

- All configuration files are symlinked from ~/.dotfiles/ to their expected locations
- The setup preserves existing files by creating .backup versions
- Modular design with separate directories for each tool
- Uses external package managers: TPM for tmux, pathogen for vim, nvm for Node.js
- Consistent theming with Catppuccin across tmux, vim, and starship

## Claude Code Skills

This repository includes custom skills for Claude Code to enhance development workflows:

### `/fix` - Bug Fix Skill
Interactive workflow for identifying, fixing, and validating bugs in Python and Node.js projects.

**Features:**
- Automatically detects project type (Python or Node.js)
- Runs tests to identify failures (pytest, jest, npm test)
- Checks for type errors (mypy, TypeScript)
- Validates syntax and execution
- Provides structured output for bug diagnosis

**Usage:**
- `/fix` - Run bug detection in current directory
- `/fix path/to/project` - Run in specific directory

**What it checks:**
- **Python:** pytest tests, mypy type checking, syntax validation
- **Node.js:** npm test, TypeScript compilation, syntax validation

See `.claude/skills/fix/reference.md` for detailed documentation.

### `/lint` - Code Quality Skill
Intelligently detects project type and runs appropriate linting tools.

**Supported languages:** Python (ruff, flake8, pylint), JavaScript/TypeScript (eslint)

## Dependencies

Required system packages for tmux from source:
```bash
sudo apt install -y libevent-dev ncurses-dev build-essential bison pkg-config
```

External tools installed by setup.sh:
- Starship prompt (via curl installer)
- TPM (Tmux Plugin Manager)
- nvm (Node Version Manager)
- Modern terminal tools:
  - zoxide (smart directory jumper)
  - bat (syntax-highlighted file viewer)
  - eza (modern ls replacement)
  - lazygit (terminal UI for git)
  - tmuxinator (requires Ruby, installed via gem)
- Catppuccin vim theme