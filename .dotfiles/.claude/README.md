# Claude Code Global Configuration

This directory contains global configuration for Claude Code that applies across all projects.

**Part of the dotfiles system:** This directory is symlinked to `~/.claude/` by the setup script, so your Claude Code configuration is version-controlled along with your other dotfiles.

## Directory Structure

```
~/.claude/
├── CLAUDE.md           # Global memory and instructions
├── README.md           # This file
├── settings.json       # Claude Code settings and permissions
├── hooks/              # Post-tool-use hooks
│   ├── README.md
│   ├── python-test-lint.sh
│   └── js-test-lint.sh
├── rules/              # Modular rule files
│   ├── python.md
│   └── react-vite.md
└── skills/             # Personal skills
    ├── cleanup-branches/
    ├── commit/
    ├── commit-pr/
    ├── commit-push/
    ├── fix/
    └── lint/
```

## Usage

### Memory (CLAUDE.md)
The `CLAUDE.md` file contains global context and preferences that Claude Code will use across all projects. Edit this file to add:
- Your role and expertise
- General coding preferences
- Common patterns you use
- Tools and workflows

### Settings (settings.json)
Configuration file for Claude Code that controls:
- Permissions for automatic command execution
- Enabled plugins (e.g., ralph-wiggum)
- Post-tool-use hooks configuration

### Hooks (hooks/)
Automated scripts that run after Claude Code edits files:
- `python-test-lint.sh` - Auto-test and lint Python files (pytest, ruff)
- `js-test-lint.sh` - Auto-test and lint JS/TS/CSS files (npm test, eslint, prettier)
- Non-blocking with smart terminal notifications
- See `hooks/README.md` for detailed documentation

### Rules (rules/)
Modular rule files for specific topics. These are automatically loaded and can be organized by category:
- `python.md` - Python coding standards (Google style, uv, type hints)
- `react-vite.md` - React + Vite development standards
- Add more as needed (e.g., `docker-practices.md`, `testing-standards.md`)

### Skills (skills/)
Skills are reusable workflows for common tasks:
- `/commit` - Create conventional git commits
- `/commit-push` - Commit and push to remote
- `/commit-pr` - Commit, push, and create PR
- `/cleanup-branches` - Remove stale local branches
- `/fix` - Interactive bug fixing workflow (Python/Node.js)
- `/lint` - Smart linting (detects project type)

## How to Use

1. **Edit CLAUDE.md** to add your personal context and preferences
2. **Create rules** for specific domains (e.g., `rules/data-science.md`)
3. **Build skills** for complex workflows that need multiple steps
4. **Restart Claude Code** or start a new session to load changes

## Examples

### Invoke a skill:
```
/commit
/fix
/lint
```

### Reference in project:
In a project's `.claude/CLAUDE.md`, you can reference global rules:
```markdown
@~/.claude/rules/python.md
```

## Tips

- Keep `CLAUDE.md` concise and high-level
- Use `rules/` for detailed, topic-specific guidelines
- Skills are ideal for complex, multi-step workflows
- Changes take effect in new sessions
