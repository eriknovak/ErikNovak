#!/bin/bash

# Intelligent project detection and linting script
# Detects Python and Node.js/React projects and runs appropriate linters

set -e

PROJECT_ROOT="${1:-.}"
FOUND_LINTERS=false
EXIT_CODE=0

echo "=== Project Linting ==="
echo "Scanning for project types in: $PROJECT_ROOT"
echo ""

# Detect Python projects
if [[ -f "$PROJECT_ROOT/pyproject.toml" ]] || [[ -f "$PROJECT_ROOT/setup.py" ]] || [[ -f "$PROJECT_ROOT/requirements.txt" ]] || ls "$PROJECT_ROOT"/*.py &>/dev/null; then
    echo "🐍 Python project detected"

    # Try ruff first (modern and fast)
    if command -v ruff &> /dev/null; then
        FOUND_LINTERS=true
        echo "Running: ruff check ."
        cd "$PROJECT_ROOT" && ruff check . || EXIT_CODE=$?
        echo ""
    # Fall back to flake8
    elif command -v flake8 &> /dev/null; then
        FOUND_LINTERS=true
        echo "Running: flake8 ."
        cd "$PROJECT_ROOT" && flake8 . || EXIT_CODE=$?
        echo ""
    # Fall back to pylint
    elif command -v pylint &> /dev/null; then
        FOUND_LINTERS=true
        echo "Running: pylint **/*.py"
        cd "$PROJECT_ROOT" && find . -name "*.py" -not -path "*/\.*" -exec pylint {} + || EXIT_CODE=$?
        echo ""
    else
        echo "❌ No Python linters found."
        echo "Install ruff (recommended) with: uv pip install ruff"
        echo "Or install flake8 with: uv pip install flake8"
        echo ""
    fi
fi

# Detect JavaScript/Node/React projects
if [[ -f "$PROJECT_ROOT/package.json" ]]; then
    echo "📦 Node.js/React project detected"

    # Check if npm run lint exists in package.json
    if grep -q '"lint"' "$PROJECT_ROOT/package.json" 2>/dev/null; then
        FOUND_LINTERS=true
        echo "Running: npm run lint"
        cd "$PROJECT_ROOT" && npm run lint || EXIT_CODE=$?
        echo ""
    # Fall back to eslint if available
    elif command -v eslint &> /dev/null; then
        FOUND_LINTERS=true
        echo "Running: eslint ."
        cd "$PROJECT_ROOT" && eslint . || EXIT_CODE=$?
        echo ""
    else
        echo "❌ No JavaScript linters found."
        echo "Install ESLint with:"
        echo "  npm install --save-dev eslint"
        echo "  npx eslint --init"
        echo ""
    fi
fi

if [[ "$FOUND_LINTERS" == false ]]; then
    echo "❓ No project type detected or no linters available."
    echo ""
    echo "Looking for:"
    echo "  Python: pyproject.toml, setup.py, requirements.txt, or *.py files"
    echo "  Node.js: package.json"
    exit 1
fi

echo "=== Linting Complete ==="
exit $EXIT_CODE
