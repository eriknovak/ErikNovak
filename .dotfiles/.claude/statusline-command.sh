#!/bin/bash

# Claude Code Status Line Script
# Displays: git:branch [status] • M: model • S: tokens percent% • L: usage% [progress bar] (XhYm left)
# With selective dimming on labels and separators

# Read JSON input from stdin
input=$(cat)

# Extract data using jq
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# ANSI codes
DIM='\033[2m'
RESET='\033[0m'

# Git information
git_branch=""
git_status=""

if [ -d "$cwd/.git" ] || git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    # Get branch name (skip optional locks)
    git_branch=$(cd "$cwd" && git -c gc.autoDetach=false branch --show-current 2>/dev/null || echo "detached")

    # Get git status indicators
    cd "$cwd"
    git_status_output=$(git -c gc.autoDetach=false status --porcelain 2>/dev/null)

    if [ -z "$git_status_output" ]; then
        git_status="clean"
    else
        status_parts=""

        # Check for modifications
        if echo "$git_status_output" | grep -q "^ M"; then
            status_parts="${status_parts}M"
        fi

        # Check for added/staged
        if echo "$git_status_output" | grep -q "^M\|^A"; then
            [ -n "$status_parts" ] && status_parts="${status_parts}:"
            status_parts="${status_parts}A"
        fi

        # Check for deleted
        if echo "$git_status_output" | grep -q "^ D\|^D"; then
            [ -n "$status_parts" ] && status_parts="${status_parts}:"
            status_parts="${status_parts}D"
        fi

        # Check for untracked
        if echo "$git_status_output" | grep -q "^??"; then
            [ -n "$status_parts" ] && status_parts="${status_parts}:"
            status_parts="${status_parts}U"
        fi

        git_status="$status_parts"
    fi
fi

# Build git section
git_section=""
if [ -n "$git_branch" ]; then
    git_section="git:${git_branch} [${git_status}]"
fi

# Calculate total tokens and percentage of context window
total_tokens=$((total_input + total_output))

# Format tokens with K suffix if > 1000
if [ $total_tokens -ge 1000 ]; then
    tokens_display="$((total_tokens / 1000))K"
else
    tokens_display="$total_tokens"
fi

# Calculate percentage of context window
if [ "$context_size" -gt 0 ]; then
    context_pct=$(echo "scale=0; $total_tokens * 100 / $context_size" | bc 2>/dev/null || echo "0")
    tokens_display="${tokens_display} ${context_pct}%"
fi

# Calculate time until limit reset
# Claude's context limits reset at midnight UTC
reset_time=""
if [ -n "$used_pct" ]; then
    current_epoch=$(date +%s)
    # Calculate seconds until next midnight UTC
    current_day_start=$(date -u -d "today 00:00:00" +%s)
    next_day_start=$((current_day_start + 86400))
    seconds_until_reset=$((next_day_start - current_epoch))

    # Convert to hours and minutes
    hours=$((seconds_until_reset / 3600))
    minutes=$(((seconds_until_reset % 3600) / 60))

    if [ $hours -gt 0 ]; then
        reset_time="${hours}h${minutes}m left"
    else
        reset_time="${minutes}m left"
    fi
fi

# Build progress bar if we have usage percentage
progress_bar=""
if [ -n "$used_pct" ]; then
    # Create a 10-character progress bar
    bar_width=10
    filled=$(printf "%.0f" $(echo "scale=0; $used_pct * $bar_width / 100" | bc 2>/dev/null || echo "0"))
    empty=$((bar_width - filled))

    # Build the bar
    bar=""
    for ((i=0; i<filled; i++)); do bar="${bar}█"; done
    for ((i=0; i<empty; i++)); do bar="${bar}░"; done

    progress_bar="[${bar}]"

    # Format percentage
    pct_display="$(printf "%.0f%%" "$used_pct")"
else
    pct_display=""
fi

# Assemble status line with selective dimming
output=""

# Git section
if [ -n "$git_section" ]; then
    output="$git_section"
fi

# Dimmed separator
SEP="${DIM}•${RESET}"

# Model section with dimmed label
if [ -n "$output" ]; then
    output="$output $SEP "
fi
output="${output}${DIM}M:${RESET} ${model}"

# Session/tokens section with dimmed label
output="$output $SEP ${DIM}S:${RESET} ${tokens_display}"

# Usage section with dimmed label and time
if [ -n "$used_pct" ]; then
    output="$output $SEP ${DIM}L:${RESET} $pct_display $progress_bar"
    if [ -n "$reset_time" ]; then
        output="$output ${DIM}(${reset_time})${RESET}"
    fi
fi

# Use printf to properly handle ANSI codes
printf "%b\n" "$output"
