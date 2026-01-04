# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) and other AI assistants when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for a data scientist's development environment. The repository contains configuration files and automated setup scripts for creating a modern, productive terminal-based development environment with consistent Catppuccin theming.

**Key Technologies:** Bash, Tmux, Vim, Nano, Git, Starship Prompt, VSCode
**Primary Use Case:** Data science and software development workflows
**Theme:** Catppuccin (Mocha variant for terminal, various themes for VSCode)

## Repository Structure

```
ErikNovak/
├── .dotfiles/                    # All configuration files
│   ├── bash/                     # Shell configuration
│   │   ├── .bashrc              # Main bash config
│   │   ├── .bash_aliases        # Comprehensive alias definitions
│   │   └── .bash_profile        # Sources .bashrc
│   ├── tmux/                     # Terminal multiplexer config
│   │   ├── .tmux.conf           # Tmux configuration
│   │   └── README.md            # Tmux setup guide
│   ├── vim/                      # Vim editor config
│   │   ├── vimrc                # Vim configuration
│   │   ├── colors/              # Color schemes
│   │   ├── autoload/            # Pathogen plugin manager
│   │   └── bundle/              # Vim plugins
│   ├── vscode/                   # VSCode preferences
│   │   └── README.md            # Extensions and themes guide
│   ├── starship/                 # Prompt configuration
│   │   └── starship.toml        # Starship config
│   ├── .gitconfig               # Git configuration
│   ├── .nanorc                  # Nano editor config
│   └── .profile                 # Shell profile
├── setup.sh                      # Main installation script
├── README.md                     # User-facing documentation
├── SETUP.md                      # Detailed setup guide
└── CLAUDE.md                     # This file (AI assistant guidance)
```

## Setup and Installation

### Primary Setup Command

```bash
./setup.sh
```

This is the main installation script that orchestrates the entire environment setup. Understanding this script is crucial for making modifications.

**What setup.sh does:**

1. **Dependency Checks:**
   - Verifies tmux is installed (exits if not)
   - Checks for existing installations before installing tools

2. **External Tools Installation:**
   - TPM (Tmux Plugin Manager) - `~/.tmux/plugins/tpm`
   - Starship prompt - via curl installer
   - nvm (Node Version Manager) - v0.40.3
   - fzf (fuzzy finder) - `~/.fzf`
   - zoxide (smart directory jumper) - via installer script
   - bat (syntax-highlighted cat) - via apt or manual
   - eza (modern ls replacement) - from GitHub releases
   - lazygit (terminal UI for git) - from GitHub releases
   - Catppuccin vim theme - cloned to vim/bundle/

3. **Directory Creation:**
   - `~/.config/` - for Starship config
   - `~/.nano/backups/` - for nano backup files

4. **Symlink Creation:**
   - Links all dotfiles from `.dotfiles/` to their expected locations in `$HOME`
   - Preserves existing files with `.backup` extension
   - See the `FILES` associative array in setup.sh:1-33 for exact mappings

5. **Git User Configuration:**
   - Prompts for Git name and email
   - Creates `~/.gitconfig.local` (included by main .gitconfig)

### Post-Setup Steps

```bash
# Apply bash configuration
source ~/.bashrc

# Start tmux and install plugins
tmux
# Press Ctrl+b then Shift+I
```

## Key Components and Configuration Files

### Shell Configuration (.dotfiles/bash/)

**`.bashrc`** (.dotfiles/bash/.bashrc:1-43)
- Sources `.bash_aliases`
- Initializes Starship prompt
- Loads nvm for Node.js version management
- Initializes zoxide with `cd` command replacement
- Sources fzf if available
- Configures SDKMAN (Java/JVM tool manager) if installed
- Adds `~/.local/bin` to PATH

**`.bash_aliases`** (.dotfiles/bash/.bash_aliases:1-165)
Comprehensive alias definitions organized by category:
- Tmux: `ta`, `ts`, `tl`, `tksv`, `tkss`
- Navigation: `..`, `...`, `....`, `.....`
- Git: `g`, `gs`, `ga`, `gaa`, `gc`, `gp`, `gl`, `gd`, `gds`, `glog`, `glg`, `gbr`, `gco`
- Python/UV: `py`, `python`, `venv`, `va`, `vd`, `pi`, `pr`, `pf`, `pl`
- System: Safe operations with `-i` flag, `du`, `df`, `psg`, `ff`, `fd`, `path`
- Modern tools: Conditional aliases for bat, eza, lazygit, tmuxinator

**`.bash_profile`** (.dotfiles/bash/.bash_profile)
- Simple profile that sources `.bashrc`

### Terminal Multiplexer (.dotfiles/tmux/)

**`.tmux.conf`** (.dotfiles/tmux/.tmux.conf)
Configuration includes:
- **Prefix:** Default `Ctrl+b`
- **Theme:** Catppuccin Mocha via TPM plugin
- **Mouse support:** Enabled
- **History:** 99,999 lines
- **Vi mode:** Enabled for copy mode
- **Custom splits:**
  - `prefix + |` - Horizontal split (opens in current dir)
  - `prefix + -` - Vertical split (opens in current dir)
- **Vim-style navigation:** `prefix + h/j/k/l`
- **Vim-style resizing:** `prefix + H/J/K/L` (repeatable)
- **Reload config:** `prefix + r`

**Plugins (via TPM):**
- tmux-sensible - Better defaults
- catppuccin/tmux - Catppuccin theme
- tmux-cpu - CPU usage in status bar
- tmux-battery - Battery status

See `.dotfiles/tmux/README.md` for complete documentation.

### Editors

**Vim** (.dotfiles/vim/)
- Plugin manager: Pathogen (autoload)
- Theme: Catppuccin
- Configuration: `vimrc`
- Plugins directory: `bundle/`

**Nano** (.dotfiles/.nanorc)
- Syntax highlighting enabled
- Backup directory: `~/.nano/backups/`
- See file for specific settings

**VSCode** (.dotfiles/vscode/README.md)
- **Dark theme:** Night Owl (no italics)
- **Light theme:** Github Plus
- **Icons:** Helium Icon Theme
- **Extensions:** See vscode/README.md for comprehensive list including:
  - Code formatting: ESLint, Prettier, Better Comments
  - Languages: Python, C/C++, npm
  - Services: Docker, Remote SSH
  - Tools: GitLens, Rainbow CSV, Live Server

### Prompt (.dotfiles/starship/)

**`starship.toml`**
- Theme: Catppuccin Mocha preset
- Customized prompt with directory, git status, language versions
- See Starship documentation for customization options

### Version Control

**`.gitconfig`** (.dotfiles/.gitconfig:1-71)

**Key settings:**
- Editor: nano
- Default branch: main
- Pull strategy: No rebase (can be changed)
- Autocorrect typos: 10 deciseconds (1 second)
- Diff algorithm: histogram
- Merge conflict style: diff3
- Color coding: Custom colors for status and diff

**Useful aliases:**
- `st` - Short status with branch
- `lg` - Pretty graph log with colors
- `last` - Show last commit with stats
- `unstage` - Unstage files
- `amend` - Amend last commit without editing message
- `br` - Show branches with last commit
- `staged` - Show diff of staged changes
- `cm` - Quick commit with message
- `up` - Pull with rebase and autostash
- `contributors` - Show contributor stats
- `files` - Show files in last commit

**`.gitconfig.local`**
- Created by setup.sh during installation
- Contains user-specific name, email, and credential helper
- Not tracked in repository (for privacy)

## Development Tools and Aliases

### Python/UV Development Shortcuts

```bash
py, python      # python3
venv            # uv venv (create virtual environment)
va              # source .venv/bin/activate
vd              # deactivate
pi              # uv pip install
pr              # uv pip install -r requirements.txt
pf              # uv pip freeze
pl              # uv pip list
```

### Git Workflow Shortcuts

```bash
g               # git
gs              # git status -sb (short, branch)
ga              # git add
gaa             # git add . (all files)
gc              # git commit -v (verbose)
gp              # git push
gl              # git pull
gd              # git diff
gds             # git diff --staged
glog            # git log --oneline --graph --decorate --all -20
glg             # git lg (custom pretty format)
gbr             # git branch -v
gco             # git checkout
```

### Tmux Session Management

```bash
tmux            # tmux -2 (256 colors)
ta              # tmux attach -t
tad             # tmux attach -d -t
ts              # tmux new-session -s
tl              # tmux list-sessions
tksv            # tmux kill-server
tkss            # tmux kill-session -t
```

### Navigation Shortcuts

```bash
..              # cd ..
...             # cd ../..
....            # cd ../../..
.....           # cd ../../../..
```

### Modern Terminal Tools

**bat** - Syntax-highlighted file viewer (better cat)
```bash
cat             # bat --paging=never (replaces cat)
catt            # bat (with paging)
catp            # bat --plain (no decorations)
```
Note: Ubuntu/Debian install as `batcat`, aliases handle this

**eza** - Modern ls replacement with icons and git integration
```bash
ls              # eza --group-directories-first --icons
l               # eza -lh (long format, human readable)
ll              # eza -lha (long, all files)
la              # eza -lha (same as ll)
lt              # eza -lh --sort=modified --reverse (sort by time)
lsize           # eza -lh --sort=size --reverse (sort by size)
tree            # eza --tree --icons
ltree           # eza --tree --level=2 --icons (2 levels deep)
```

**zoxide** - Smart directory jumper (learns from usage)
```bash
cd              # Aliased to 'z' (smart jump)
cdi             # Interactive directory selection (with fzf)
```
Zoxide learns your frequently used directories and lets you jump to them with partial names.

**lazygit** - Terminal UI for git
```bash
lg              # lazygit
```
Full-featured TUI for git operations with keyboard shortcuts.

**tmuxinator** - Tmux session manager
```bash
mux             # tmuxinator
muxs            # tmuxinator start [session]
muxn            # tmuxinator new [session]
muxl            # tmuxinator list
```
Requires Ruby. Define project layouts in YAML for quick session creation.

**fzf** - Fuzzy finder
- Installed to `~/.fzf/`
- Provides `Ctrl+R` for command history search
- Integrates with zoxide for `cdi` command
- Can be used standalone for fuzzy finding

## Architecture and Design Patterns

### Symlink-Based Configuration

All configuration files remain in the repository at `~/.dotfiles/` and are symlinked to their expected locations. This design:
- Keeps configurations version-controlled
- Allows easy updates via git pull
- Preserves existing files with `.backup` extension
- Enables selective configuration installation

### Modular Organization

Each tool has its own directory with configuration files and documentation:
```
.dotfiles/
  ├── bash/          # Shell configs
  ├── tmux/          # Tmux with README
  ├── vim/           # Vim with plugins
  ├── vscode/        # VSCode with README
  └── starship/      # Prompt config
```

### External Package Managers

Rather than bundling everything, the setup uses established package managers:
- **TPM:** Tmux plugin management
- **Pathogen:** Vim plugin management
- **nvm:** Node.js version management
- **SDKMAN:** JVM tool management (optional)

### Consistent Theming

Catppuccin theme is used consistently across:
- Tmux (Mocha variant)
- Vim (Catppuccin plugin)
- Starship (Mocha preset)

VSCode uses different themes (Night Owl for dark, Github Plus for light) as preferred by the user.

### Conditional Functionality

Aliases and configurations check for tool availability before enabling features:
- bat/batcat alias detection (.bash_aliases:130-139)
- eza conditionally replaces ls (.bash_aliases:142-151)
- Tool-specific aliases only if command exists

## Dependencies and Requirements

### Required System Packages

For tmux compilation (Debian/Ubuntu):
```bash
sudo apt install -y libevent-dev ncurses-dev build-essential bison pkg-config
```

### Recommended: Install tmux from source

```bash
cd /tmp
wget https://github.com/tmux/tmux/releases/download/3.6a/tmux-3.6a.tar.gz
tar -xzf tmux-3.6a.tar.gz
cd tmux-3.6a
./configure && make && sudo make install
```

### External Tools (Installed by setup.sh)

| Tool | Installation Method | Purpose |
|------|-------------------|---------|
| Starship | curl installer | Modern prompt |
| TPM | git clone | Tmux plugin manager |
| nvm | curl installer (v0.40.3) | Node.js version manager |
| fzf | git clone + install script | Fuzzy finder |
| zoxide | curl installer | Smart directory navigation |
| bat | apt or GitHub release | Syntax-highlighted file viewer |
| eza | GitHub release | Modern ls replacement |
| lazygit | GitHub release | Git TUI |
| tmuxinator | Ruby gem (if Ruby installed) | Tmux session manager |
| Catppuccin vim | git clone | Vim color scheme |

### Optional Dependencies

- **Ruby:** Required for tmuxinator
- **SDKMAN:** For JVM tool management (auto-detected in .bashrc)
- **uv:** Python package manager (aliases configured but not auto-installed)

## Working with This Repository (AI Assistant Guidelines)

### Before Making Changes

1. **Always read the relevant configuration file first** before suggesting modifications
2. **Check SETUP.md** for user-facing documentation that may need updates
3. **Test symlink behavior** - remember files are linked, not copied
4. **Verify tool availability** - check if tools are installed before adding config

### When Modifying Configuration Files

**For .bashrc, .bash_aliases:**
- Maintain the section organization with clear headers
- Add new aliases to the appropriate category
- Use conditional checks for tool-specific configurations
- Test with `bash -n <file>` for syntax errors

**For .tmux.conf:**
- Respect the existing key binding scheme
- Test with `tmux source-file ~/.tmux.conf`
- Document new key bindings in tmux/README.md
- Maintain Catppuccin theme integration

**For .gitconfig:**
- Keep user-specific settings in .gitconfig.local
- Test new aliases before committing
- Maintain color scheme consistency

**For setup.sh:**
- Test on a clean environment if possible
- Maintain idempotent behavior (safe to run multiple times)
- Update the FILES array if adding new symlinks
- Add appropriate error checking and user feedback
- Use the established color-coded output format

### File Modification Workflow

When updating configurations:

1. **Read the current file** to understand existing patterns
2. **Make targeted changes** - avoid unnecessary reformatting
3. **Update related documentation:**
   - This CLAUDE.md file for AI assistant guidance
   - README.md for user-facing changes
   - SETUP.md for installation procedures
   - Tool-specific READMEs (tmux/README.md, vscode/README.md)
4. **Test the changes** if possible:
   - Source bashrc: `source ~/.bashrc`
   - Reload tmux: `prefix + r`
   - Test git aliases: `git <alias>`
5. **Commit with descriptive messages** following existing conventions

### Adding New Tools

When adding a new tool to the environment:

1. **Add installation logic to setup.sh:**
   - Check if already installed
   - Install with appropriate method
   - Provide feedback with color-coded output
   - Handle errors gracefully

2. **Add configuration:**
   - Create config file in appropriate .dotfiles/ subdirectory
   - Add symlink entry to FILES array in setup.sh
   - Consider creating a README.md for complex tools

3. **Add aliases to .bash_aliases:**
   - Group in appropriate category or create new section
   - Use conditional checks: `if command -v tool &> /dev/null; then`

4. **Update documentation:**
   - Add to this CLAUDE.md under appropriate sections
   - Update README.md with brief description
   - Update SETUP.md if installation requires special steps

5. **Consider theming:**
   - Check if tool supports Catppuccin theme
   - Maintain visual consistency

### Common Tasks

**Adding a new alias:**
1. Read `.dotfiles/bash/.bash_aliases`
2. Add to appropriate section with comment
3. Test: `source ~/.bashrc && type <alias>`
4. Update CLAUDE.md if significant

**Adding a tmux key binding:**
1. Read `.dotfiles/tmux/.tmux.conf`
2. Add binding with descriptive comment
3. Document in `.dotfiles/tmux/README.md`
4. Test: `tmux source-file ~/.tmux.conf`

**Adding a git alias:**
1. Read `.dotfiles/.gitconfig`
2. Add to `[alias]` section with comment
3. Update CLAUDE.md git aliases list
4. Test: `git <alias>`

**Updating Starship prompt:**
1. Read `.dotfiles/starship/starship.toml`
2. Consult Starship docs: https://starship.rs/config/
3. Test: `starship config` validates TOML
4. Changes apply on next prompt

### Troubleshooting Common Issues

**Symlinks not working:**
- Check that setup.sh ran successfully
- Verify source files exist in .dotfiles/
- Check `ls -la ~/` to confirm symlinks

**Tmux plugins not loading:**
- Ensure TPM is installed: `ls ~/.tmux/plugins/tpm`
- Press `prefix + I` to install plugins
- Check tmux version: `tmux -V` (needs 2.1+)

**Aliases not available:**
- Source bashrc: `source ~/.bashrc`
- Check .bash_aliases is sourced in .bashrc
- Verify tool is installed: `command -v <tool>`

**Git aliases not working:**
- Check ~/.gitconfig.local exists
- Test: `git config --list | grep alias`
- Verify syntax in .gitconfig

**Color scheme issues:**
- Verify terminal supports 256 colors: `echo $TERM`
- Tmux needs `-2` flag (handled by alias)
- Check TERM inside tmux: `echo $TERM` should show `screen-256color` or `tmux-256color`

## Version Information and Compatibility

**Tested on:**
- Ubuntu/Debian Linux systems
- Bash 4.0+
- Tmux 3.6a
- Git 2.0+

**Tool Versions (as of last update):**
- nvm: v0.40.3
- Starship: Latest stable
- Tmux: 3.6a recommended
- External tools: Latest releases from GitHub

## Additional Resources

- **Starship docs:** https://starship.rs/
- **Tmux docs:** https://github.com/tmux/tmux/wiki
- **Catppuccin theme:** https://github.com/catppuccin/catppuccin
- **eza docs:** https://github.com/eza-community/eza
- **bat docs:** https://github.com/sharkdp/bat
- **zoxide docs:** https://github.com/ajeetdsouza/zoxide
- **lazygit docs:** https://github.com/jesseduffield/lazygit
- **fzf docs:** https://github.com/junegunn/fzf

## Notes for AI Assistants

- This is a personal dotfiles repository - prioritize user preferences over "best practices"
- The user is a data scientist - Python/data science workflows are important
- Maintain the Catppuccin theming where appropriate
- Keep configurations simple and well-documented
- Preserve the modular structure
- Always test suggestions before presenting them
- Reference specific line numbers when discussing code: `file.sh:123`
- Be conservative with changes - dotfiles are highly personal
