#!/bin/bash

# Python Test & Lint Hook for Claude Code
# Purpose: Auto-test and lint Python files after edits

# Read JSON input from stdin
INPUT=$(cat)

# Extract file path using jq
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path' 2>/dev/null)

# Skip if not a Python file
if [[ ! "$FILE" =~ \.py$ ]] || [ -z "$FILE" ]; then
    exit 0
fi

# Skip if file doesn't exist
if [ ! -f "$FILE" ]; then
    exit 0
fi

# ===== TESTING =====
if command -v pytest &> /dev/null; then
    pytest "$FILE" -q --tb=short &> /dev/null
fi

# ===== LINTING =====
if command -v ruff &> /dev/null; then
    ruff check --fix "$FILE" &> /dev/null
fi

# Always exit 0 (non-blocking)
exit 0
