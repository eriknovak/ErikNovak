---
name: lint
description: Intelligently detects project type (Node.js/React or Python) and runs appropriate linting tools. Use when checking code quality or validating project for style issues.
user-invocable: true
allowed-tools: Read, Bash(python:*), Bash(npm:*), Bash(pnpm:*), Bash(uv:*), Bash(ruff:*), Bash(eslint:*), Bash(flake8:*)
---

# Linting Skill

Automatically detects your project type and runs the appropriate linter.

## Supported Project Types

- **Python**: Uses `ruff check`, `flake8`, or `pylint` based on availability
- **JavaScript/Node/React**: Uses `npm run lint`, `eslint`, or scripts in package.json
- **Multi-language**: Runs linting for all detected project types

## Usage

Simply ask Claude to lint your project:
- "Lint this project"
- "Check for code style issues"
- "Run linters"
- "Check code quality"

Or use the slash command: `/lint`

## How It Works

1. Detects project type by scanning for configuration files:
   - Python: `pyproject.toml`, `setup.py`, `requirements.txt`, `.py` files
   - JavaScript: `package.json`

2. Identifies available linters in each project

3. Runs linters and reports results with actionable feedback

## Linting Strategy

### Python Projects (Priority Order)
1. **ruff** - Modern, fast linter (preferred for data science work)
2. **flake8** - Classic PEP 8 style checker
3. **pylint** - Comprehensive static analyzer

### Node.js/React Projects (Priority Order)
1. **npm run lint** - Uses project's configured lint script
2. **eslint** - Standard JavaScript/React linter
3. Provides setup instructions if no linter found

## Advanced Usage

For more details on linting best practices and configuration, see [reference.md](reference.md).

## Troubleshooting

- **No linters found**: Skill provides installation instructions for your project type
- **Python linters**: Install with `uv pip install ruff` (recommended)
- **Node linters**: Install with `npm install --save-dev eslint`
