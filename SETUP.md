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

### Optional: Ruby (for tmuxinator)

```bash
sudo apt install ruby
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
- **zoxide** - Smart directory jumper
- **bat** - Syntax-highlighted file viewer
- **eza** - Modern ls replacement with icons
- **delta** - Enhanced git diff viewer
- **lazygit** - Terminal UI for git
- **tmuxinator** - Tmux session manager (requires Ruby)
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

### 4. Optional: Configure zoxide

Zoxide learns from your directory navigation. Just use it normally with `cd` (aliased to `z`):

```bash
cd ~/projects
cd ~/documents
# Later, jump directly:
cd proj  # Takes you to ~/projects
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
| `cd <dir>` | Smart jump to directory (zoxide) |
| `cdi` | Interactive directory selection |
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

### File Viewing (bat-enhanced)

| Command | Description |
|---------|-------------|
| `cat <file>` | View with syntax highlighting (no paging) |
| `catt <file>` | View with syntax highlighting (with paging) |
| `catp <file>` | View plain text (no decorations) |

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

### Modern Tool Commands

| Command | Description |
|---------|-------------|
| `lg` | Launch lazygit |
| `mux` | tmuxinator |
| `muxs <session>` | Start tmuxinator session |
| `muxn <session>` | Create new tmuxinator session |
| `muxl` | List tmuxinator sessions |

### FZF Integration (if fzf installed)

| Command | Description |
|---------|-------------|
| `preview` | Preview files with bat |
| `vf` | Open file in vim with fzf search |
| `cdf` | Fuzzy find and cd into directory |

---

## Modern Tools Guide

### bat - Enhanced File Viewer

Replacement for `cat` with syntax highlighting and line numbers:

```bash
cat script.py          # View with highlighting (no paging)
catt large_file.log    # View with paging
catp config.json       # Plain text, no decorations
```

**Features:**
- Automatic syntax highlighting
- Git integration (shows modifications)
- Line numbers
- Catppuccin theme

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

### zoxide - Smart Directory Navigation

Learns your most-used directories and enables quick jumping:

```bash
# Normal usage (builds history)
cd ~/projects/data-science
cd ~/documents/reports

# Later, jump with partial names
cd data       # Jumps to ~/projects/data-science
cd rep        # Jumps to ~/documents/reports

# Interactive selection
cdi           # Shows menu of frequent directories
```

**Features:**
- Frecency algorithm (frequency + recency)
- Partial matching
- Interactive mode

### delta - Git Diff Viewer

Automatically used by git for better diffs:

```bash
gd                    # Shows unstaged changes with delta
gds                   # Shows staged changes with delta
git diff main         # Any git diff uses delta
```

**Features:**
- Side-by-side view option
- Syntax highlighting in diffs
- Line numbers
- Catppuccin Mocha theme
- Better merge conflict visualization

### lazygit - Terminal UI for Git

Interactive git interface:

```bash
lg                    # Launch lazygit
```

**Features:**
- Visual commit history
- Interactive staging
- Branch management
- Merge conflict resolution
- Quick commands

### tmuxinator - Tmux Session Manager

Manage complex tmux layouts:

```bash
muxn my-project       # Create new project layout
muxs my-project       # Start project session
muxl                  # List all projects
```

Create a project file at `~/.config/tmuxinator/my-project.yml`:

```yaml
name: my-project
root: ~/projects/my-project

windows:
  - editor: vim
  - server: npm run dev
  - shell:
```

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

### bat shows as "batcat" on Ubuntu

The setup script creates a symlink automatically. If it's missing:

```bash
mkdir -p ~/.local/bin
ln -sf /usr/bin/batcat ~/.local/bin/bat
```

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

### zoxide not working

Make sure it's initialized:

```bash
source ~/.bashrc
```

Verify zoxide is in PATH:
```bash
which zoxide
```

### Git delta not showing

Check git configuration:

```bash
git config --get core.pager
# Should output: delta
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

### 2. Create Tmuxinator Projects

Set up project-specific tmux layouts:

```bash
muxn data-analysis
```

### 3. Explore Vim Configuration

The vim setup includes:
- Catppuccin Mocha theme
- Pathogen plugin manager
- Custom key bindings

Add plugins to `~/.dotfiles/vim/bundle/`

### 4. Install Additional Tools

- **fzf** - Fuzzy finder (enables preview, vf, cdf commands)
  ```bash
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
  ```

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
- [bat Documentation](https://github.com/sharkdp/bat)
- [zoxide Documentation](https://github.com/ajeetdsouza/zoxide)
- [lazygit Documentation](https://github.com/jesseduffield/lazygit)

---

## Contributing

This is a personal dotfiles repository, but feel free to fork and customize for your own use!

---

**Happy coding!**
