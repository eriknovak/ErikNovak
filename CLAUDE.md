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
- Symlinks `~/.claude/` for Claude Code configuration
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

The setup script symlinks `~/.dotfiles/.dotfiles/.claude/` to `~/.claude/`, providing version-controlled Claude Code configuration.

### Directory Structure

```
~/.claude/
├── CLAUDE.md           # Global instructions and preferences
├── settings.json       # Permissions, hooks, and skill config
├── agents/             # Specialized agent definitions
├── commands/           # Custom slash commands
├── hooks/              # Pre/post tool-use hooks
├── rules/              # Modular development guidelines
└── skills/             # Personal skills for workflows
```

### Custom Skills

Skills are reusable workflows invoked with slash commands:

#### `/commit` - Conventional Commits
Creates well-formatted git commits following Conventional Commits spec.
- Analyzes staged changes to determine commit type
- Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore
- Prompts for user approval before committing

#### `/commit-push` - Commit and Push
Combines commit workflow with automatic push to remote.
- Creates conventional commit
- Handles new branches with `git push -u`
- Checks remote tracking before pushing

#### `/commit-pr` - Commit, Push, and Create PR
Complete workflow for pull request creation.
- Creates conventional commit and pushes
- Uses GitHub CLI (gh) for PR creation
- Generates PR body from commit messages
- Supports draft PRs, labels, and reviewers

#### `/fix` - Bug Fix Workflow
Interactive bug fixing for Python and Node.js projects.
- Automatically detects project type
- Runs tests (pytest, npm test)
- Checks for type errors (mypy, TypeScript)
- Validates fixes before completing

**What it checks:**
- **Python:** pytest tests, mypy type checking, syntax validation
- **Node.js:** npm test, TypeScript compilation, syntax validation

#### `/lint` - Code Quality
Intelligently detects project type and runs appropriate linting tools.
- **Python:** ruff (preferred), flake8, pylint
- **JavaScript/TypeScript:** eslint

#### `/proofread` - Document Proofreading
Senior editor proofreading for grammar, structure, and notation.
- Especially useful for LaTeX and scientific writing
- Highlights mistakes with explanations
- Suggests specific fixes

#### `/secrets` - Security Audit
Audits codebase for secret handling issues.

**What it checks:**
- Committed `.env` files and secret files in git
- Missing `.gitignore` patterns for sensitive files
- Missing `.env.example` templates
- Hardcoded secrets (AWS keys, GitHub tokens, Stripe keys, passwords)
- Private key content in source files

**Output:**
- Issues by severity: CRITICAL, HIGH, MEDIUM, LOW
- Specific files and line numbers
- Remediation actions

### Custom Commands

#### `/latex-build` - LaTeX Compilation
Builds LaTeX projects using pdflatex + bibtex with three-pass compilation.
- Handles bibliography compilation
- Reports errors and warnings

### Specialized Agents

Four custom agents available via Task tool:

#### `academic-publisher`
Academic publishing advisor for venue selection.
- Analyzes papers and recommends journals/conferences
- Provides submission guidelines and checklists
- Searches for current deadlines and impact factors

#### `developer-frontend`
UI/UX development expert for React applications.
- React + Vite component architecture
- Accessibility (WCAG 2.1 AA) standards
- CSS Modules and BEM naming conventions
- Design system tokens and UX patterns

#### `developer-backend`
Backend development expert for APIs and services.
- API design and security practices
- Database patterns and optimization
- Authentication/authorization implementation
- Frontend/service integration

#### `developer-reviewer`
Senior code reviewer for quality assurance.
- Security vulnerability detection
- Bug identification and edge case analysis
- Design pattern consistency
- Language-specific focus (Python, JS/TS, React)

### Development Rules

Modular guidelines in `~/.claude/rules/` auto-loaded by Claude:

- **python.md** - Google Style Guide, type hints, uv, pytest
- **react-vite.md** - Project structure, CSS Modules, Storybook, Vitest
- **scientific-papers.md** - Paper structure, LaTeX notation, citations

### Automated Hooks

#### PreToolUse: Secrets Protection (`block-secrets.sh`)
Runs **before** Read, Edit, or Write operations to block access to sensitive files.

**Blocked patterns:**
- Environment files: `.env`, `.env.*`
- Credentials: `credentials.json`, `secrets.json`, `secrets.yaml`
- Private keys: `*.pem`, `*.key`, `id_rsa`, `id_ed25519`
- SSH directory: `~/.ssh/*`
- Cloud credentials: `~/.aws/credentials`, `~/.kube/config`
- Auth files: `.npmrc`, `.netrc`, `~/.docker/config.json`
- Terraform state: `*.tfstate`

**Behavior:** Blocking - prevents the operation entirely

#### PostToolUse: Python Testing & Linting (`python-test-lint.sh`)
Runs automatically when `.py` files are edited:
- **Testing:** Runs `pytest` on modified file
- **Linting:** Runs `ruff check --fix` with auto-fixes

#### PostToolUse: JS/TS Testing & Linting (`js-test-lint.sh`)
Runs automatically when `.js`, `.jsx`, `.ts`, `.tsx`, `.css`, `.scss` files are edited:
- **Testing:** Runs `npm test` (JS/TS only)
- **Linting:** `eslint --fix` (JS/TS), `stylelint --fix` (CSS/SCSS)
- **Formatting:** `prettier --write`

**Behavior:** Non-blocking, silent on success

## Dependencies

Required system packages for tmux from source:
```bash
sudo apt install -y libevent-dev ncurses-dev build-essential bison pkg-config
```

External tools installed by setup.sh:
- Starship prompt (via curl installer)
- TPM (Tmux Plugin Manager)
- nvm (Node Version Manager)
- Modern terminal tools: eza
- Catppuccin vim theme

Optional tools (recommended for hooks):
- Python: `pytest`, `ruff`, `mypy`
- JavaScript: `eslint`, `prettier`, `stylelint`