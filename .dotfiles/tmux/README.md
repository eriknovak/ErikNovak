# TMUX Configuration

## Installation

### Prerequisites

Before installing tmux, ensure you have the required system dependencies:

```bash
sudo apt update
sudo apt install -y libevent-dev ncurses-dev build-essential bison pkg-config
```

### Install tmux from source

It is recommended to install tmux from source to get the latest version:

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

## Setup

### TPM (Tmux Plugin Manager)

The `setup.sh` script automatically installs TPM if it's not already present. TPM is required to manage all the plugins configured in `.tmux.conf`.

If you need to install TPM manually:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### Installing Plugins

After running `setup.sh` and starting tmux for the first time:

1. Start a tmux session: `tmux`
2. Press `prefix + I` (capital i) to fetch and install all plugins
   - Default prefix is `Ctrl + b`, so press `Ctrl + b` then `Shift + i`

You should see a message indicating plugins are being installed.

### Updating Plugins

To update all plugins: `prefix + U`

### Removing Plugins

If you remove a plugin from `.tmux.conf`, press `prefix + alt + u` to uninstall it.

## Included Plugins

- **tpm** - Tmux Plugin Manager
- **tmux-sensible** - Sensible default settings for tmux
- **catppuccin/tmux** - Beautiful Catppuccin Mocha theme
- **tmux-cpu** - CPU usage display in status bar
- **tmux-battery** - Battery status display in status bar
- **tmux-resurrect** - Session persistence (save/restore sessions)

## Custom Key Bindings

### Window/Pane Management

- `prefix + |` - Split window horizontally (opens in current directory)
- `prefix + -` - Split window vertically (opens in current directory)
- `prefix + c` - Create new window (opens in current directory)

### Navigation (Vim-style)

- `prefix + h/j/k/l` - Navigate between panes (left/down/up/right)

### Resizing (Repeatable)

- `prefix + H/J/K/L` - Resize pane by 5 cells (left/down/up/right)

### Other

- `prefix + z` - Toggle pane zoom (fullscreen)
- `prefix + r` - Reload tmux configuration

### Copy Mode (Vi-style)

- Enter copy mode: `prefix + [`
- Start selection: `v`
- Copy selection: `y`
- Paste: `prefix + ]`

### Session Persistence (tmux-resurrect)

- `prefix + Ctrl-s` - Save session
- `prefix + Ctrl-r` - Restore session

## Features

- **Mouse support** - Enabled for scrolling, pane selection, and resizing
- **256 color terminal** - Full color support
- **High history limit** - 99,999 lines of scrollback
- **Vi-style key bindings** - For copy mode
- **Activity monitoring** - Visual notification when activity occurs in other windows
- **Automatic window renumbering** - Windows are renumbered when one is closed