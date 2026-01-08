#!/bin/bash

# React/NodeJS Test & Lint Hook for Claude Code
# Purpose: Auto-test and lint JS/TS/CSS/SCSS files after edits with smart notifications

# Source notification functions from bash aliases
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

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

FILENAME=$(basename "$FILE")
EXT="${FILE##*.}"
TEST_RESULT=0
LINT_RESULT=0
HAS_TEST=false
HAS_LINTER=false
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
    # Check if package.json exists and has test script
    if [ -f "package.json" ] && grep -q '"test"' package.json 2>/dev/null; then
        if command -v npm &> /dev/null; then
            HAS_TEST=true

            # Try to run test on specific file
            # Note: This may not work for all test setups, so we use || true
            npm test -- "$FILE" &> /dev/null || npm test &> /dev/null
            TEST_RESULT=$?
        fi
    fi
fi

# ===== LINTING =====
if [ "$IS_JS_TS" = true ]; then
    # Check for ESLint
    if command -v npx &> /dev/null && [ -f "node_modules/.bin/eslint" ]; then
        HAS_LINTER=true

        # Capture eslint output before fix
        LINT_BEFORE=$(npx eslint "$FILE" 2>&1 || true)

        # Run eslint with auto-fix
        npx eslint --fix "$FILE" &> /dev/null || true
        LINT_RESULT=$?

        # Capture eslint output after fix
        LINT_AFTER=$(npx eslint "$FILE" 2>&1 || true)
    fi
elif [ "$IS_CSS" = true ]; then
    # Check for Stylelint
    if command -v npx &> /dev/null && [ -f "node_modules/.bin/stylelint" ]; then
        HAS_LINTER=true

        # Capture stylelint output before fix
        LINT_BEFORE=$(npx stylelint "$FILE" 2>&1 || true)

        # Run stylelint with auto-fix
        npx stylelint --fix "$FILE" &> /dev/null || true
        LINT_RESULT=$?

        # Capture stylelint output after fix
        LINT_AFTER=$(npx stylelint "$FILE" 2>&1 || true)
    fi
fi

# ===== FORMATTING (All file types) =====
if command -v npx &> /dev/null; then
    # Run prettier (silent operation)
    npx prettier --write "$FILE" &> /dev/null || true
fi

# ===== SMART NOTIFICATION LOGIC =====

# If no tools available, exit silently
if [ "$HAS_TEST" = false ] && [ "$HAS_LINTER" = false ]; then
    exit 0
fi

# Determine if we should notify
SHOULD_NOTIFY=false
NOTIFY_TYPE=""
NOTIFY_MSG=""

# Check test results
if [ "$HAS_TEST" = true ]; then
    if [ $TEST_RESULT -ne 0 ]; then
        SHOULD_NOTIFY=true
        NOTIFY_TYPE="action"
        NOTIFY_MSG="Tests failed: $FILENAME - Review needed"
    fi
fi

# Check linting results
if [ "$HAS_LINTER" = true ]; then
    # Check if there are still errors after auto-fix
    if [[ "$LINT_AFTER" =~ error ]] || [[ "$LINT_AFTER" =~ "✖" ]]; then
        SHOULD_NOTIFY=true
        NOTIFY_TYPE="action"
        if [ -n "$NOTIFY_MSG" ]; then
            NOTIFY_MSG="$NOTIFY_MSG | Linting errors in $FILENAME"
        else
            NOTIFY_MSG="Linting errors in $FILENAME"
        fi
    elif [ "$LINT_BEFORE" != "$LINT_AFTER" ]; then
        # Auto-fixes were applied, but don't notify (silent success)
        :
    fi
fi

# If everything passed and we ran tools, notify success
if [ "$SHOULD_NOTIFY" = false ] && { [ "$HAS_TEST" = true ] || [ "$HAS_LINTER" = true ]; }; then
    if [ "$HAS_TEST" = true ] && [ $TEST_RESULT -eq 0 ]; then
        SHOULD_NOTIFY=true
        NOTIFY_TYPE="done"
        NOTIFY_MSG="Tests passed: $FILENAME"
    elif [ "$HAS_LINTER" = true ] && [ $LINT_RESULT -eq 0 ]; then
        # Only notify if no tests ran and linting is clean
        if [ "$HAS_TEST" = false ]; then
            # For CSS/SCSS files or JS/TS without tests
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
