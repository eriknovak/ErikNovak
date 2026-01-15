# Claude Code Hooks

This directory contains post-edit hooks that automatically test and lint code after Claude Code edits files.

## Overview

Hooks are triggered by the `PostToolUse` event configured in `~/.claude/settings.json`. They run automatically when Claude Code uses the `Write` or `Edit` tools on supported file types.

## Available Hooks

### `python-test-lint.sh`

**Triggers:** When `.py` files are edited

**Actions:**
1. **Testing:** Runs `pytest` on the modified file
2. **Linting:** Runs `ruff check --fix` with automatic fixes

**Exit Codes:**
- Always exits 0 (non-blocking)

**Requirements:**
- `pytest` (optional) - For running tests
- `ruff` (optional) - For linting
- `jq` - For parsing JSON input

### `js-test-lint.sh`

**Triggers:** When `.js`, `.jsx`, `.ts`, `.tsx`, `.css`, or `.scss` files are edited

**Actions:**
1. **Testing (JS/TS only):** Runs `npm test` on the modified file
2. **Linting:**
   - JS/TS: `eslint --fix` with automatic fixes
   - CSS/SCSS: `stylelint --fix` with automatic fixes
3. **Formatting:** Runs `prettier --write` on all file types

**Exit Codes:**
- Always exits 0 (non-blocking)

**Requirements:**
- `npm` (optional) - For running tests
- `eslint` (optional) - For JS/TS linting
- `stylelint` (optional) - For CSS/SCSS linting
- `prettier` (optional) - For formatting
- `jq` - For parsing JSON input

## Hook Configuration

Hooks are configured in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/python-test-lint.sh",
            "timeout": 30
          },
          {
            "type": "command",
            "command": "~/.claude/hooks/js-test-lint.sh",
            "timeout": 45
          }
        ]
      }
    ]
  }
}
```

## Permissions

The hooks require certain bash commands to run without prompts. These are pre-approved in `~/.claude/settings.json`:

```json
{
  "permissions": {
    "allow": [
      "Bash(cat:*)",
      "Bash(tree:*)",
      "Bash(chmod:*)"
    ]
  }
}
```

The hooks themselves also have automatic approval in settings:

```json
{
  "permissions": {
    "allow": [
      "Bash(~/.claude/hooks/python-test-lint.sh:*)",
      "Bash(~/.claude/hooks/js-test-lint.sh:*)"
    ]
  }
}
```

## Customization

To customize hook behavior, edit the shell scripts directly:

### Adjust Timeouts

Increase timeout in `settings.json` if hooks run slowly:

```json
"timeout": 60  // Increase from 30 to 60 seconds
```

### Disable Specific Hooks

Comment out hooks in `settings.json`:

```json
// {
//   "type": "command",
//   "command": "~/.claude/hooks/python-test-lint.sh",
//   "timeout": 30
// }
```

### Add Custom Checks

Extend the scripts to add additional tools:

```bash
# Add mypy type checking to Python hook
if command -v mypy &> /dev/null; then
    mypy "$FILE" &> /dev/null
fi
```

## Troubleshooting

### Hooks Not Running

1. Check settings.json syntax:
   ```bash
   jq . ~/.claude/settings.json
   ```

2. Verify hook permissions:
   ```bash
   ls -l ~/.claude/hooks/*.sh
   # Should show: -rwx--x--x (executable)
   ```

3. Test hook manually:
   ```bash
   echo '{"tool_input":{"file_path":"test.py"}}' | ~/.claude/hooks/python-test-lint.sh
   ```

### Tools Not Found

Install missing tools:

```bash
# Python
pip install pytest ruff

# JavaScript/TypeScript
npm install --save-dev eslint prettier stylelint
```

## Contributing

To add a new hook:

1. Create script in `.dotfiles/.claude/hooks/`
2. Make executable: `chmod +x hook-name.sh`
3. Add to `settings.json` under `PostToolUse` hooks
4. Test with sample input
5. Update this README

## References

- [Claude Code Hooks Documentation](https://github.com/anthropics/claude-code)
- [Settings Configuration](.dotfiles/.claude/settings.json)
