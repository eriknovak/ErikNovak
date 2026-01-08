---
name: fix
description: Interactive bug fixing workflow for Python and Node.js projects. Identifies issues, suggests fixes, and validates the fix works. Use when debugging errors or fixing specific bugs.
user-invocable: true
allowed-tools: Read, Edit, Write, Bash(python:*), Bash(pytest:*), Bash(npm:*), Bash(node:*), Bash(uv:*), Bash(mypy:*), Bash(tsc:*), Grep, Glob
---

# Bug Fix Skill

Interactive workflow to identify, fix, and validate bugs in Python and Node.js projects.

## Usage

Ask Claude to fix bugs:
- "Fix this bug"
- "Help me debug this error"
- "Fix the failing test"
- "Resolve this issue"

Or use the slash command: `/fix`

## How It Works

### 1. Identify the Bug
- Examines recent git changes
- Checks for error messages or stack traces
- Runs relevant tests to reproduce the issue
- Identifies the root cause

### 2. Suggest Fixes
- Proposes specific code changes
- Explains the reasoning behind each fix
- Considers multiple approaches if applicable

### 3. Apply the Fix
- Makes targeted code changes
- Follows project coding standards
- Preserves existing functionality

### 4. Validate the Fix
- Runs relevant tests to verify the fix
- Checks for type errors (mypy/tsc)
- Ensures no new issues were introduced
- Confirms the original issue is resolved

## Supported Languages

- **Python**: pytest, mypy, script execution
- **JavaScript/Node.js**: jest/mocha, TypeScript checking, script execution

## Workflow Example

```
1. Running tests to identify failing cases...
2. Found error in auth.py:42 - undefined variable 'user_id'
3. Suggesting fix: Add user_id parameter to function signature
4. Applying fix to auth.py
5. Running tests again... ✓ All tests pass
6. Fix validated successfully!
```

## Tips

- Provide error messages or stack traces for faster diagnosis
- Specify which test is failing if known
- The skill focuses on fixing one bug at a time for clarity
