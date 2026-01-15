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
- Installs modern terminal tools (eza)
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
- **eza** - Modern ls replacement with icons and git integration
  - `ls` - basic listing with icons
  - `l`, `ll`, `la` - various detailed listings
  - `tree` - tree view
  - `ltree` - tree view (2 levels)

## Architecture Notes

- All configuration files are symlinked from ~/.dotfiles/ to their expected locations
- The setup preserves existing files by creating .backup versions
- Modular design with separate directories for each tool
- Uses external package managers: TPM for tmux, pathogen for vim, nvm for Node.js
- Consistent theming with Catppuccin across tmux, vim, and starship

## Claude Code Integration

### Installation

Claude Code is automatically installed by the setup script. After installation, authenticate with:

```bash
claude auth
```

### Custom Skills

This repository includes custom skills for Claude Code to enhance development workflows:

#### `/fix` - Bug Fix Skill
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

#### `/lint` - Code Quality Skill
Intelligently detects project type and runs appropriate linting tools.

**Supported languages:** Python (ruff, flake8, pylint), JavaScript/TypeScript (eslint)

#### `/secrets` - Secrets Audit Skill
Audits codebase for proper secret handling and identifies potential security issues.

**What it checks:**
- Committed `.env` files and other secret files in git
- Missing `.gitignore` patterns for sensitive files
- Missing `.env.example` templates
- Hardcoded secrets in source code (AWS keys, GitHub tokens, Stripe keys, passwords)
- Private key content embedded in source files

**Usage:**
- `/secrets` - Audit current directory
- Reports issues by severity: CRITICAL, HIGH, MEDIUM, LOW

**Output:**
- Specific files and line numbers with potential secrets
- Recommended remediation actions
- Summary of issues found

See `.claude/skills/secrets/reference.md` for secret patterns and remediation steps.

### Automated Testing & Linting Hooks

Post-edit hooks automatically test and lint code after Claude Code edits files:

#### Python Hook (`~/.claude/hooks/python-test-lint.sh`)
Runs automatically when `.py` files are edited:
- **Testing:** Runs `pytest` on modified file
- **Linting:** Runs `ruff check --fix` with auto-fixes

#### JavaScript/TypeScript Hook (`~/.claude/hooks/js-test-lint.sh`)
Runs automatically when `.js`, `.jsx`, `.ts`, `.tsx`, `.css`, or `.scss` files are edited:
- **Testing:** Runs `npm test` on modified file (JS/TS only)
- **Linting:**
  - JS/TS: `eslint --fix` with auto-fixes
  - CSS/SCSS: `stylelint --fix` with auto-fixes
- **Formatting:** `prettier --write` for all file types

**Hook Behavior:**
- Non-blocking (won't prevent edits)
- Silent operation (auto-fixes applied without output)

#### Secrets Protection Hook (`~/.claude/hooks/block-secrets.sh`)
Runs **before** Read, Edit, or Write operations to block access to sensitive files.

**Blocked file patterns:**
- Environment files: `.env`, `.env.*`
- Credentials: `credentials.json`, `secrets.json`, `secrets.yaml`
- Private keys: `*.pem`, `*.key`, `id_rsa`, `id_ed25519`, etc.
- SSH directory: `~/.ssh/*`
- Cloud credentials: `~/.aws/credentials`, `~/.kube/config`, service account JSONs
- Auth files: `.npmrc`, `.netrc`, `.htpasswd`, `~/.docker/config.json`
- Terraform state: `*.tfstate`
- Token/password/API key files

**Hook Behavior:**
- **Blocking** - prevents the operation entirely
- Returns clear error message explaining why access was denied

**Hook Permissions:**
The hooks are pre-approved in `.claude/settings.json` to run without prompts.

## Dependencies

Required system packages for tmux from source:
```bash
sudo apt install -y libevent-dev ncurses-dev build-essential bison pkg-config
```

External tools installed by setup.sh:
- Starship prompt (via curl installer)
- TPM (Tmux Plugin Manager)
- nvm (Node Version Manager)
- Claude Code (AI coding assistant)
- Modern terminal tools:
  - eza (modern ls replacement)
- Catppuccin vim theme

Optional tools (recommended for hooks):
- Python: `pytest`, `ruff` (for testing/linting)
- JavaScript: `eslint`, `prettier`, `stylelint` (for linting/formatting)