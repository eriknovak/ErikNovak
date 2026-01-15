#!/bin/bash

# React/NodeJS Test & Lint Hook for Claude Code
# Purpose: Auto-test and lint JS/TS/CSS/SCSS files after edits

# Read JSON input from stdin
INPUT=$(cat)

# Extract file path using jq
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path' 2>/dev/null)

# Skip if not a JS/TS/CSS/SCSS file
if [[ ! "$FILE" =~ \.(js|jsx|ts|tsx|css|scss)$ ]] || [ -z "$FILE" ]; then
    exit 0
fi

# Skip if file doesn't exist
if [ ! -f "$FILE" ]; then
    exit 0
fi

IS_JS_TS=false
IS_CSS=false

# Determine file type
if [[ "$FILE" =~ \.(js|jsx|ts|tsx)$ ]]; then
    IS_JS_TS=true
elif [[ "$FILE" =~ \.(css|scss)$ ]]; then
    IS_CSS=true
fi

# ===== TESTING (JS/TS only) =====
if [ "$IS_JS_TS" = true ]; then
    if [ -f "package.json" ] && grep -q '"test"' package.json 2>/dev/null; then
        if command -v npm &> /dev/null; then
            npm test -- "$FILE" &> /dev/null || npm test &> /dev/null
        fi
    fi
fi

# ===== LINTING =====
if [ "$IS_JS_TS" = true ]; then
    if command -v npx &> /dev/null && [ -f "node_modules/.bin/eslint" ]; then
        npx eslint --fix "$FILE" &> /dev/null || true
    fi
elif [ "$IS_CSS" = true ]; then
    if command -v npx &> /dev/null && [ -f "node_modules/.bin/stylelint" ]; then
        npx stylelint --fix "$FILE" &> /dev/null || true
    fi
fi

# ===== FORMATTING (All file types) =====
if command -v npx &> /dev/null; then
    npx prettier --write "$FILE" &> /dev/null || true
fi

# Always exit 0 (non-blocking)
exit 0
