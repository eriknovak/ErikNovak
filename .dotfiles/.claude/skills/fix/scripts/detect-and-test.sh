#!/bin/bash

# Bug detection and validation script
# Detects Python and Node.js/React projects and runs tests/checks to identify issues

set -e

PROJECT_ROOT="${1:-.}"
FOUND_ISSUES=false
EXIT_CODE=0

echo "=== Bug Detection & Validation ==="
echo "Analyzing project in: $PROJECT_ROOT"
echo ""

# Detect Python projects
if [[ -f "$PROJECT_ROOT/pyproject.toml" ]] || [[ -f "$PROJECT_ROOT/setup.py" ]] || [[ -f "$PROJECT_ROOT/requirements.txt" ]] || ls "$PROJECT_ROOT"/*.py &>/dev/null; then
    echo "🐍 Python project detected"
    echo ""

    # Run pytest if available
    if command -v pytest &> /dev/null; then
        echo "Running: pytest -v"
        if cd "$PROJECT_ROOT" && pytest -v 2>&1; then
            echo "✓ All tests passed"
        else
            FOUND_ISSUES=true
            EXIT_CODE=1
            echo "✗ Tests failed - see output above"
        fi
        echo ""
    else
        echo "ℹ️  pytest not found - install with: uv pip install pytest"
        echo ""
    fi

    # Run mypy if available
    if command -v mypy &> /dev/null; then
        echo "Running: mypy ."
        if cd "$PROJECT_ROOT" && mypy . 2>&1; then
            echo "✓ No type errors found"
        else
            FOUND_ISSUES=true
            echo "✗ Type errors found - see output above"
        fi
        echo ""
    fi

    # Try to run main Python files to check for runtime errors
    MAIN_FILES=$(find "$PROJECT_ROOT" -maxdepth 2 -name "main.py" -o -name "__main__.py" -o -name "app.py" 2>/dev/null)
    if [[ -n "$MAIN_FILES" ]]; then
        for file in $MAIN_FILES; do
            echo "Checking syntax: python -m py_compile $file"
            if python -m py_compile "$file" 2>&1; then
                echo "✓ No syntax errors in $file"
            else
                FOUND_ISSUES=true
                EXIT_CODE=1
                echo "✗ Syntax errors in $file"
            fi
            echo ""
        done
    fi
fi

# Detect JavaScript/Node/React projects
if [[ -f "$PROJECT_ROOT/package.json" ]]; then
    echo "📦 Node.js/React project detected"
    echo ""

    # Check if test script exists in package.json
    if grep -q '"test"' "$PROJECT_ROOT/package.json" 2>/dev/null; then
        echo "Running: npm test"
        if cd "$PROJECT_ROOT" && npm test 2>&1; then
            echo "✓ All tests passed"
        else
            FOUND_ISSUES=true
            EXIT_CODE=1
            echo "✗ Tests failed - see output above"
        fi
        echo ""
    else
        echo "ℹ️  No test script found in package.json"
        echo ""
    fi

    # Run TypeScript compiler if tsconfig.json exists
    if [[ -f "$PROJECT_ROOT/tsconfig.json" ]] && command -v tsc &> /dev/null; then
        echo "Running: tsc --noEmit"
        if cd "$PROJECT_ROOT" && tsc --noEmit 2>&1; then
            echo "✓ No TypeScript errors found"
        else
            FOUND_ISSUES=true
            echo "✗ TypeScript errors found - see output above"
        fi
        echo ""
    fi

    # Try to check for syntax errors in main file
    if grep -q '"main"' "$PROJECT_ROOT/package.json" 2>/dev/null; then
        MAIN_FILE=$(grep '"main"' "$PROJECT_ROOT/package.json" | sed 's/.*"main".*:.*"\(.*\)".*/\1/')
        if [[ -f "$PROJECT_ROOT/$MAIN_FILE" ]]; then
            echo "Checking syntax: node --check $MAIN_FILE"
            if cd "$PROJECT_ROOT" && node --check "$MAIN_FILE" 2>&1; then
                echo "✓ No syntax errors in $MAIN_FILE"
            else
                FOUND_ISSUES=true
                EXIT_CODE=1
                echo "✗ Syntax errors in $MAIN_FILE"
            fi
            echo ""
        fi
    fi
fi

if [[ "$FOUND_ISSUES" == true ]]; then
    echo "=== Issues Found ==="
    echo "Review the errors above to identify and fix bugs"
    exit $EXIT_CODE
else
    echo "=== No Issues Found ==="
    echo "All checks passed successfully!"
    exit 0
fi
