#!/bin/bash

# Python Test & Lint Hook for Claude Code
# Purpose: Auto-test and lint Python files after edits with smart notifications

# Source notification functions from bash aliases
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

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

FILENAME=$(basename "$FILE")
PYTEST_RESULT=0
RUFF_RESULT=0
HAS_PYTEST=false
HAS_RUFF=false

# ===== TESTING =====
if command -v pytest &> /dev/null; then
    HAS_PYTEST=true

    # Run pytest on the file
    pytest "$FILE" -q --tb=short &> /dev/null
    PYTEST_RESULT=$?
fi

# ===== LINTING =====
if command -v ruff &> /dev/null; then
    HAS_RUFF=true

    # Capture ruff output before fix
    RUFF_BEFORE=$(ruff check "$FILE" 2>&1)

    # Run ruff with auto-fix
    ruff check --fix "$FILE" &> /dev/null
    RUFF_RESULT=$?

    # Capture ruff output after fix
    RUFF_AFTER=$(ruff check "$FILE" 2>&1)
fi

# ===== SMART NOTIFICATION LOGIC =====

# If no tools available, exit silently
if [ "$HAS_PYTEST" = false ] && [ "$HAS_RUFF" = false ]; then
    exit 0
fi

# Determine if we should notify
SHOULD_NOTIFY=false
NOTIFY_TYPE=""
NOTIFY_MSG=""

# Check test results
if [ "$HAS_PYTEST" = true ]; then
    if [ $PYTEST_RESULT -ne 0 ]; then
        SHOULD_NOTIFY=true
        NOTIFY_TYPE="action"
        NOTIFY_MSG="Tests failed: $FILENAME - Review needed"
    fi
fi

# Check linting results
if [ "$HAS_RUFF" = true ]; then
    # If there are errors after auto-fix, notify
    if [ $RUFF_RESULT -ne 0 ]; then
        SHOULD_NOTIFY=true
        NOTIFY_TYPE="action"
        if [ -n "$NOTIFY_MSG" ]; then
            NOTIFY_MSG="$NOTIFY_MSG | Linting errors in $FILENAME"
        else
            NOTIFY_MSG="Linting errors in $FILENAME"
        fi
    elif [ "$RUFF_BEFORE" != "$RUFF_AFTER" ]; then
        # Auto-fixes were applied, but don't notify (silent success)
        :
    fi
fi

# If everything passed and we ran tools, notify success
if [ "$SHOULD_NOTIFY" = false ] && { [ "$HAS_PYTEST" = true ] || [ "$HAS_RUFF" = true ]; }; then
    if [ "$HAS_PYTEST" = true ] && [ $PYTEST_RESULT -eq 0 ]; then
        SHOULD_NOTIFY=true
        NOTIFY_TYPE="done"
        NOTIFY_MSG="Tests passed: $FILENAME"
    elif [ "$HAS_RUFF" = true ] && [ $RUFF_RESULT -eq 0 ]; then
        # Only notify if no tests ran and ruff is clean
        if [ "$HAS_PYTEST" = false ]; then
            SHOULD_NOTIFY=true
            NOTIFY_TYPE="done"
            NOTIFY_MSG="Code quality checks passed: $FILENAME"
        fi
    fi
fi

# Send notification if needed
if [ "$SHOULD_NOTIFY" = true ]; then
    if [ "$NOTIFY_TYPE" = "done" ]; then
        notify-done "$NOTIFY_MSG"
    elif [ "$NOTIFY_TYPE" = "action" ]; then
        notify-action "$NOTIFY_MSG"
    fi
fi

# Always exit 0 (non-blocking)
exit 0
