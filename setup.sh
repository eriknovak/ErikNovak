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
)

# Create nano backup directory
mkdir -p "$HOME/.nano/backups"
echo -e "${GREEN}✓${NC} Created nano backup directory"

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

echo -e "\n${BLUE}========================================${NC}"
echo -e "${GREEN}Setup complete!${NC}"
echo -e "${BLUE}========================================${NC}\n"

echo -e "To apply the changes, run:"
echo -e "  ${BLUE}source ~/.bashrc${NC}"
echo -e "\nOr restart your terminal.\n"

echo -e "${YELLOW}Note:${NC} Don't forget to update .gitconfig with your actual name and email:"
echo -e "  ${BLUE}nano ~/.gitconfig${NC}\n"
