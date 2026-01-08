# Dotfiles Setup Guide

A modern, data science-focused development environment featuring tmux, vim, starship prompt, and powerful terminal tools with Catppuccin theming.

## Table of Contents

- [Quick Start](#quick-start)
- [Prerequisites](#prerequisites)
- [Detailed Installation](#detailed-installation)
- [Post-Installation Configuration](#post-installation-configuration)
- [Available Commands](#available-commands)
- [Modern Tools Guide](#modern-tools-guide)
- [Tmux Usage](#tmux-usage)
- [Troubleshooting](#troubleshooting)

---

## Quick Start

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run the setup script
./setup.sh

# Apply the changes
source ~/.bashrc

# Set up tmux plugins
tmux
# Press Ctrl+b then Shift+I to install plugins
```

---

## Prerequisites

### Required System Packages

For **Debian/Ubuntu** systems, install tmux build dependencies:

```bash
sudo apt update
sudo apt install -y libevent-dev ncurses-dev build-essential bison pkg-config
```

### Install tmux from Source (Recommended)

For the latest features and compatibility with the configuration:

```bash
cd /tmp
wget https://github.com/tmux/tmux/releases/download/3.6a/tmux-3.6a.tar.gz
tar -xzf tmux-3.6a.tar.gz
cd tmux-3.6a
./configure
make
sudo make install
```

Verify installation:

```bash
tmux -V
```

---

## Detailed Installation

The `setup.sh` script automates the entire installation process. Here's what it does:

### 1. Check Dependencies

- Verifies tmux is installed
- Guides you to installation instructions if missing

### 2. Install Essential Tools

The script automatically installs the following if not present:

- **TPM** (Tmux Plugin Manager) - Manages tmux plugins
- **Starship** - Modern, fast shell prompt
- **nvm** - Node Version Manager
- **Claude Code** - AI coding assistant with automatic testing/linting
- **eza** - Modern ls replacement with icons
- **Catppuccin vim theme** - Beautiful vim color scheme

### 3. Create Symlinks

Creates symlinks from `~/.dotfiles/` to your home directory for:

- `.bashrc`, `.bash_aliases`, `.bash_profile`, `.profile`
- `.gitconfig`, `.nanorc`, `.vimrc`
- `.tmux.conf`
- `.config/starship.toml`

**Note:** Existing files are backed up with a `.backup` extension.

### 4. Configure Git

Prompts for your Git name and email, creating `~/.gitconfig.local`:

```
[user]
    name = Your Name
    email = your.email@example.com
```

### 5. Create Necessary Directories

- `~/.config/` - Configuration directory
- `~/.nano/backups/` - Nano backup files location

---

## Post-Installation Configuration

### 1. Apply Shell Changes

```bash
source ~/.bashrc
# Or restart your terminal
```

### 2. Install Node.js (via nvm)

```bash
nvm install --lts
nvm use --lts
```

### 3. Set Up Tmux Plugins

```bash
# Start tmux
tmux

# Inside tmux, press: Ctrl+b then Shift+I
# Wait for plugins to install
```

### 4. Authenticate Claude Code

```bash
# Follow the prompts to authenticate with your API key
claude auth
```

---

## Available Commands

### Tmux Session Management

| Command | Description |
|---------|-------------|
| `tmux` | Start tmux with 256 colors |
| `ta <session>` | Attach to session |
| `tad <session>` | Attach to session, detach others |
| `ts <session>` | Create new session |
| `tl` | List all sessions |
| `tkss <session>` | Kill specific session |
| `tksv` | Kill tmux server |

### Navigation

| Command | Description |
|---------|-------------|
| `cd <dir>` | Change directory |
| `..` | Go up one directory |
| `...` | Go up two directories |
| `....` | Go up three directories |
| `.....` | Go up four directories |

### File Listing (eza-enhanced)

| Command | Description |
|---------|-------------|
| `ls` | List with icons, directories first |
| `l` | Long format with icons |
| `ll` | Long format with hidden files |
| `la` | Long format all files |
| `lt` | Sort by modification time |
| `lsize` | Sort by file size |
| `tree` | Display directory tree |
| `ltree` | Display tree (2 levels) |

### Git Commands

#### Basic Operations

| Command | Description |
|---------|-------------|
| `g` | git |
| `gs` | Status with short format |
| `ga <file>` | Add file |
| `gaa` | Add all files |
| `gc` | Commit with verbose output |
| `gp` | Push to remote |
| `gl` | Pull from remote |

#### Diffing and Logs

| Command | Description |
|---------|-------------|
| `gd` | Show unstaged changes (with delta) |
| `gds` | Show staged changes (with delta) |
| `glog` | Graphical log (last 20 commits) |
| `glg` | Beautiful colorful log with graph |

#### Git Aliases (via .gitconfig)

| Command | Description |
|---------|-------------|
| `git st` | Short status with branch |
| `git lg` | Colorful graph log |
| `git last` | Show last commit with stats |
| `git unstage` | Unstage files |
| `git amend` | Amend last commit (no edit) |
| `git staged` | Diff of staged changes |
| `git cm "msg"` | Quick commit with message |
| `git up` | Pull with rebase and autostash |
| `git contributors` | Show contributor stats |

#### Branch Management

| Command | Description |
|---------|-------------|
| `gbr` | List branches with last commit |
| `gco <branch>` | Checkout branch |

### Python/UV Development

| Command | Description |
|---------|-------------|
| `py` | python3 |
| `python` | python3 |
| `venv` | Create uv virtual environment |
| `va` | Activate .venv |
| `vd` | Deactivate virtual environment |
| `pi <package>` | Install with uv pip |
| `pr` | Install from requirements.txt |
| `pf` | Freeze dependencies |
| `pl` | List installed packages |

### System Utilities

| Command | Description |
|---------|-------------|
| `rm`, `cp`, `mv` | Safe mode (asks before overwriting) |
| `du` | Disk usage (human-readable, depth 1) |
| `df` | Disk free space (human-readable) |
| `psg <process>` | Search for process |
| `ff <name>` | Find files by name |
| `fd <name>` | Find directories by name |
| `path` | Show PATH in readable format |

---

## Modern Tools Guide

### eza - Modern ls Replacement

Enhanced file listing with icons and git status:

```bash
ls                     # Basic listing with icons
ll                     # Detailed with hidden files
tree                   # Full directory tree
ltree                  # Tree limited to 2 levels
lt                     # Sort by modification time
lsize                  # Sort by file size
```

**Features:**
- Icons for file types
- Git status indicators
- Color-coded file types
- Smart directory grouping

### Claude Code - AI Coding Assistant

Powerful AI assistant integrated into your terminal:

```bash
claude                         # Start interactive session
claude "write a python script" # One-off task
claude auth                    # Authenticate
```

**Automatic Testing & Linting:**

Post-edit hooks automatically run after Claude Code edits files:
- **Python files** - Runs pytest and ruff with auto-fixes
- **JS/TS files** - Runs npm test, eslint, and prettier
- **CSS/SCSS files** - Runs stylelint and prettier

Terminal notifications alert you to:
- Test failures
- Unfixable lint errors
- Successful checks (tests passed)

Hooks are non-blocking and exit silently on success.

---

## Tmux Usage

### Basic Commands

**Starting/Attaching:**
```bash
tmux                  # Start new session
ta my-session         # Attach to "my-session"
ts my-session         # Create named session
tl                    # List all sessions
```

**Inside tmux (prefix = Ctrl+b):**

| Key Binding | Action |
|-------------|--------|
| `prefix + c` | New window (in current directory) |
| `prefix + \|` | Split horizontally |
| `prefix + -` | Split vertically |
| `prefix + h/j/k/l` | Navigate panes (vim-style) |
| `prefix + H/J/K/L` | Resize pane (repeatable) |
| `prefix + z` | Toggle pane zoom |
| `prefix + r` | Reload tmux config |
| `prefix + d` | Detach from session |

### Copy Mode (Vi-style)

| Key Binding | Action |
|-------------|--------|
| `prefix + [` | Enter copy mode |
| `v` | Start selection |
| `y` | Copy selection |
| `prefix + ]` | Paste |

### Plugin Management

| Key Binding | Action |
|-------------|--------|
| `prefix + I` | Install plugins |
| `prefix + U` | Update plugins |
| `prefix + alt + u` | Uninstall removed plugins |

### Tmux Features

- **Mouse support** - Click to select panes, scroll through history
- **256 colors** - Full color support
- **99,999 line history** - Extensive scrollback
- **Activity monitoring** - Visual notifications
- **Catppuccin Mocha theme** - Beautiful, consistent theming
- **Status bar** - Shows CPU, battery, date/time

---

## Troubleshooting

### tmux plugins not loading

1. Verify TPM is installed:
   ```bash
   ls ~/.tmux/plugins/tpm
   ```

2. Reload tmux config:
   ```bash
   # Inside tmux
   # Press: Ctrl+b then :
   # Type: source-file ~/.tmux.conf
   ```

3. Install plugins:
   ```bash
   # Press: Ctrl+b then Shift+I
   ```

### Colors not displaying correctly

Ensure your terminal supports 256 colors:

```bash
echo $TERM
# Should output: xterm-256color or screen-256color
```

Add to `~/.bashrc` if needed:
```bash
export TERM=xterm-256color
```

### Node.js/npm commands not found

Install Node.js via nvm:

```bash
source ~/.bashrc
nvm install --lts
nvm use --lts
```

---

## Next Steps

### 1. Customize Your Git Config

Edit `~/.gitconfig.local` to add user-specific settings:

```bash
nano ~/.gitconfig.local
```

### 2. Explore Vim Configuration

The vim setup includes:
- Catppuccin Mocha theme
- Pathogen plugin manager
- Custom key bindings

Add plugins to `~/.dotfiles/vim/bundle/`

### 3. Install Additional Tools

- **ripgrep** - Fast text search
  ```bash
  sudo apt install ripgrep
  ```

### 5. Set Up Starship Modules

Edit `~/.dotfiles/starship/starship.toml` to customize your prompt.

---

## Additional Resources

- [Tmux Cheat Sheet](https://tmuxcheatsheet.com/)
- [Starship Documentation](https://starship.rs/)
- [Catppuccin Theme](https://github.com/catppuccin/catppuccin)
- [eza Documentation](https://github.com/eza-community/eza)

---

## Contributing

This is a personal dotfiles repository, but feel free to fork and customize for your own use!

---

**Happy coding!**
