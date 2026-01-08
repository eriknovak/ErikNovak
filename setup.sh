#!/bin/bash

#============================
# Dotfiles Setup Script
#============================
# This script creates symlinks from your home directory
# to the dotfiles in this repository

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Dotfiles Setup${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Files and their destinations
declare -A FILES=(
    [".dotfiles/bash/.bashrc"]="$HOME/.bashrc"
    [".dotfiles/bash/.bash_aliases"]="$HOME/.bash_aliases"
    [".dotfiles/bash/.bash_profile"]="$HOME/.bash_profile"
    [".dotfiles/.profile"]="$HOME/.profile"
    [".dotfiles/.gitconfig"]="$HOME/.gitconfig"
    [".dotfiles/.nanorc"]="$HOME/.nanorc"
    [".dotfiles/tmux/.tmux.conf"]="$HOME/.tmux.conf"
    [".dotfiles/vim/vimrc"]="$HOME/.vimrc"
    [".dotfiles/starship/starship.toml"]="$HOME/.config/starship.toml"
    [".dotfiles/.claude/CLAUDE.md"]="$HOME/.claude/CLAUDE.md"
    [".dotfiles/.claude/README.md"]="$HOME/.claude/README.md"
    [".dotfiles/.claude/settings.json"]="$HOME/.claude/settings.json"
    [".dotfiles/.claude/rules"]="$HOME/.claude/rules"
    [".dotfiles/.claude/skills"]="$HOME/.claude/skills"
)

# Check for tmux installation
if ! command -v tmux &> /dev/null; then
    echo -e "${YELLOW}⚠${NC}  tmux is not installed."
    echo -e "  See ${BLUE}.dotfiles/tmux/README.md${NC} for installation instructions."
    exit 1
fi
echo -e "${GREEN}✓${NC} tmux is installed"

# Install TPM (Tmux Plugin Manager) if not present
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo -e "${BLUE}Installing TPM (Tmux Plugin Manager)...${NC}"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo -e "${GREEN}✓${NC} TPM installed"
else
    echo -e "${GREEN}✓${NC} TPM already installed"
fi

# Install Starship if not present
if ! command -v starship &> /dev/null; then
    echo -e "${BLUE}Installing Starship prompt...${NC}"
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    echo -e "${GREEN}✓${NC} Starship installed"
else
    echo -e "${GREEN}✓${NC} Starship already installed"
fi

# Install nvm (Node Version Manager) if not present
if [ ! -d "$HOME/.nvm" ]; then
    echo -e "${BLUE}Installing nvm (Node Version Manager)...${NC}"
    # PROFILE=/dev/null prevents nvm from modifying .bashrc (we already have the config)
    PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash'
    echo -e "${GREEN}✓${NC} nvm installed"
    echo -e "${YELLOW}Note:${NC} Run 'source ~/.bashrc' then 'nvm install --lts' to install Node.js"
else
    echo -e "${GREEN}✓${NC} nvm already installed"
fi

# Install fzf (fuzzy finder)
if ! command -v fzf &> /dev/null; then
    echo -e "${BLUE}Installing fzf...${NC}"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
    echo -e "${GREEN}✓${NC} fzf installed"
else
    echo -e "${GREEN}✓${NC} fzf already installed"
fi

# Install zoxide (smart directory jumper)
if ! command -v zoxide &> /dev/null; then
    echo -e "${BLUE}Installing zoxide...${NC}"
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    echo -e "${GREEN}✓${NC} zoxide installed"
else
    echo -e "${GREEN}✓${NC} zoxide already installed"
fi

# Install bat (cat with syntax highlighting)
if ! command -v bat &> /dev/null; then
    echo -e "${BLUE}Installing bat...${NC}"
    if command -v apt &> /dev/null; then
        # Debian/Ubuntu
        sudo apt install -y bat
        # Create symlink as Ubuntu installs it as batcat
        mkdir -p ~/.local/bin
        ln -sf /usr/bin/batcat ~/.local/bin/bat 2>/dev/null || true
    else
        echo -e "${YELLOW}⚠${NC}  Please install bat manually: https://github.com/sharkdp/bat"
    fi
    echo -e "${GREEN}✓${NC} bat installed"
else
    echo -e "${GREEN}✓${NC} bat already installed"
fi

# Install eza (modern ls replacement)
if ! command -v eza &> /dev/null; then
    echo -e "${BLUE}Installing eza...${NC}"
    if command -v apt &> /dev/null; then
        # Debian/Ubuntu - install from GitHub releases
        EZA_VERSION=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
        wget -q "https://github.com/eza-community/eza/releases/download/v${EZA_VERSION}/eza_x86_64-unknown-linux-gnu.tar.gz" -O /tmp/eza.tar.gz
        sudo tar -xzf /tmp/eza.tar.gz -C /usr/local/bin
        rm /tmp/eza.tar.gz
        echo -e "${GREEN}✓${NC} eza installed"
    else
        echo -e "${YELLOW}⚠${NC}  Please install eza manually: https://github.com/eza-community/eza"
    fi
else
    echo -e "${GREEN}✓${NC} eza already installed"
fi

# Install lazygit (terminal UI for git)
if ! command -v lazygit &> /dev/null; then
    echo -e "${BLUE}Installing lazygit...${NC}"
    if command -v apt &> /dev/null; then
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
        wget -q "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" -O /tmp/lazygit.tar.gz
        sudo tar -xzf /tmp/lazygit.tar.gz -C /usr/local/bin lazygit
        rm /tmp/lazygit.tar.gz
        echo -e "${GREEN}✓${NC} lazygit installed"
    else
        echo -e "${YELLOW}⚠${NC}  Please install lazygit manually: https://github.com/jesseduffield/lazygit"
    fi
else
    echo -e "${GREEN}✓${NC} lazygit already installed"
fi

# Install Claude Code (AI coding assistant)
if ! command -v claude-code &> /dev/null && ! command -v claude &> /dev/null; then
    echo -e "${BLUE}Installing Claude Code...${NC}"

    # Detect platform
    case "$(uname -s)" in
        Linux*)     PLATFORM=Linux;;
        Darwin*)    PLATFORM=Mac;;
        CYGWIN*|MINGW*|MSYS*) PLATFORM=Windows;;
        *)          PLATFORM=Unknown;;
    esac

    if [ "$PLATFORM" = "Windows" ]; then
        echo -e "${YELLOW}⚠${NC}  Windows detected. Please run the following in PowerShell:"
        echo -e "  ${BLUE}irm https://claude.ai/install.ps1 | iex${NC}"
        echo -e "  Then run 'claude auth' to authenticate with your API key"
    else
        # Unix/Mac: Use official curl installer (installs standalone binary)
        curl -fsSL https://claude.ai/install.sh | bash
        echo -e "${GREEN}✓${NC} Claude Code installed"
        echo -e "${YELLOW}Note:${NC} Run 'claude auth' to authenticate with your API key"
    fi
else
    echo -e "${GREEN}✓${NC} Claude Code already installed"
fi

# Install Catppuccin vim theme if not present
if [ ! -d "$DOTFILES_DIR/.dotfiles/vim/bundle/catppuccin" ]; then
    echo -e "${BLUE}Installing Catppuccin vim theme...${NC}"
    git clone https://github.com/catppuccin/vim.git "$DOTFILES_DIR/.dotfiles/vim/bundle/catppuccin"
    echo -e "${GREEN}✓${NC} Catppuccin vim theme installed"
else
    echo -e "${GREEN}✓${NC} Catppuccin vim theme already installed"
fi

# Create necessary directories
mkdir -p "$HOME/.config"

# Create nano backup directory
mkdir -p "$HOME/.nano/backups"
echo -e "${GREEN}✓${NC} Created nano backup directory"

# Create Claude Code directory
mkdir -p "$HOME/.claude"
echo -e "${GREEN}✓${NC} Created ~/.claude directory"

# Function to create symlink
create_symlink() {
    local source="$1"
    local dest="$2"

    # Backup existing file
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo -e "${YELLOW}⚠${NC}  Backing up existing $(basename $dest) to ${dest}.backup"
        mv "$dest" "${dest}.backup"
    fi

    # Remove existing symlink
    if [ -L "$dest" ]; then
        rm "$dest"
    fi

    # Create new symlink
    ln -s "$source" "$dest"
    echo -e "${GREEN}✓${NC} Linked $(basename $dest)"
}

# Prompt for Git user configuration
configure_git_user() {
    echo -e "\n${BLUE}Git Configuration${NC}"

    # Check if already configured
    if [ -f "$HOME/.gitconfig.local" ]; then
        echo -e "${GREEN}✓${NC} Git user config already exists (~/.gitconfig.local)"
        return
    fi

    # Prompt for name
    read -p "Enter your Git name: " git_name

    # Prompt for email with validation
    while true; do
        read -p "Enter your Git email: " git_email
        if [[ "$git_email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
            break
        else
            echo -e "${YELLOW}⚠${NC}  Invalid email format. Please try again."
        fi
    done

    # Prompt for credential helper
    echo -e "\n${BLUE}Select credential helper:${NC}"
    echo "  1) cache - Cache credentials in memory (default, 15 min timeout)"
    echo "  2) store - Store credentials in plain text file (~/.git-credentials)"
    echo "  3) none - Don't configure credential helper"
    read -p "Enter choice [1-3] (default: 1): " cred_choice
    cred_choice=${cred_choice:-1}

    # Build config file
    cat > "$HOME/.gitconfig.local" << EOF
[user]
    name = $git_name
    email = $git_email
EOF

    # Add credential helper based on choice
    case $cred_choice in
        1)
            cat >> "$HOME/.gitconfig.local" << EOF
[credential]
    helper = cache
EOF
            echo -e "${GREEN}✓${NC} Configured credential helper: cache"
            ;;
        2)
            cat >> "$HOME/.gitconfig.local" << EOF
[credential]
    helper = store
EOF
            echo -e "${GREEN}✓${NC} Configured credential helper: store"
            echo -e "${YELLOW}⚠${NC}  Warning: Credentials will be stored in plain text at ~/.git-credentials"
            ;;
        3)
            echo -e "${BLUE}ℹ${NC}  Skipped credential helper configuration"
            ;;
        *)
            cat >> "$HOME/.gitconfig.local" << EOF
[credential]
    helper = cache
EOF
            echo -e "${YELLOW}⚠${NC}  Invalid choice, defaulting to cache"
            ;;
    esac

    echo -e "${GREEN}✓${NC} Created ~/.gitconfig.local"
}

# Create symlinks for all files
for file in "${!FILES[@]}"; do
    source_file="$DOTFILES_DIR/$file"
    dest_file="${FILES[$file]}"

    if [ -e "$source_file" ]; then
        create_symlink "$source_file" "$dest_file"
    else
        echo -e "${YELLOW}⚠${NC}  Source file not found: $source_file"
    fi
done

# Configure Git user
configure_git_user

echo -e "\n${BLUE}========================================${NC}"
echo -e "${GREEN}Setup complete!${NC}"
echo -e "${BLUE}========================================${NC}\n"

echo -e "To apply the changes, run:"
echo -e "  ${BLUE}source ~/.bashrc${NC}"
echo -e "\nOr restart your terminal.\n"

echo -e "${YELLOW}Tmux Setup:${NC}"
echo -e "  1. Start tmux: ${BLUE}tmux${NC}"
echo -e "  2. Install plugins: Press ${BLUE}Ctrl+b${NC} then ${BLUE}Shift+I${NC}"
echo -e "  3. See ${BLUE}.dotfiles/tmux/README.md${NC} for more information\n"

