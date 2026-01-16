# Claude Code Hooks

This directory contains hooks that run before or after Claude Code tool use.

## Overview

Hooks are triggered by `PreToolUse` and `PostToolUse` events configured in `~/.claude/settings.json`. They provide:
- **Security:** Block access to sensitive files before operations
- **Quality:** Auto-test and lint code after edits

## Available Hooks

### `block-secrets.sh` (PreToolUse)

**Triggers:** Before `Read`, `Edit`, or `Write` operations

**Purpose:** Prevents Claude Code from accessing sensitive files.

**Blocked patterns:**
- Environment files: `.env`, `.env.*`
- Credentials: `credentials.json`, `secrets.json`, `secrets.yaml`
- Private keys: `*.pem`, `*.key`, `id_rsa`, `id_ed25519`, `id_ecdsa`
- SSH config: `~/.ssh/*`
- Cloud credentials: `~/.aws/credentials`, `~/.kube/config`
- Auth files: `.npmrc`, `.netrc`, `.htpasswd`, `~/.docker/config.json`
- GPG secrets: `~/.gnupg/*`
- Terraform state: `*.tfstate`
- Token/password/API key files

**Exit Codes:**
- `0` - File is safe, proceed
- `2` - File blocked, operation denied

**Behavior:** Blocking - prevents the operation entirely with clear error message.

### `python-test-lint.sh` (PostToolUse)

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
    "PreToolUse": [
      {
        "matcher": "Read|Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "/home/erikn/.claude/hooks/block-secrets.sh",
            "timeout": 5
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "/home/erikn/.claude/hooks/python-test-lint.sh",
            "timeout": 30
          },
          {
            "type": "command",
            "command": "/home/erikn/.claude/hooks/js-test-lint.sh",
            "timeout": 45
          }
        ]
      }
    ]
  }
}
```

## Permissions

The settings.json pre-approves common development commands:

```json
{
  "permissions": {
    "allow": [
      "Bash(cat:*)",
      "Bash(tree:*)",
      "Bash(chmod:*)",
      "Bash(git:*)",
      "Bash(npm:*)",
      "Bash(pytest:*)",
      "Bash(ruff:*)"
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
