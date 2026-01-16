# Claude Code Global Configuration

This directory contains global configuration for Claude Code that applies across all projects.

**Part of the dotfiles system:** This directory is symlinked to `~/.claude/` by the setup script, so your Claude Code configuration is version-controlled along with your other dotfiles.

## Directory Structure

```
~/.claude/
├── CLAUDE.md           # Global instructions and preferences
├── README.md           # This file
├── settings.json       # Permissions, hooks, and skill config
├── agents/             # Specialized agent definitions
│   ├── academic-publisher.md
│   ├── developer-backend.md
│   ├── developer-frontend.md
│   └── developer-reviewer.md
├── commands/           # Custom slash commands
│   └── latex-build.md
├── hooks/              # Pre/post tool-use hooks
│   ├── README.md
│   ├── block-secrets.sh      # PreToolUse: blocks secret file access
│   ├── python-test-lint.sh   # PostToolUse: pytest + ruff
│   └── js-test-lint.sh       # PostToolUse: npm test + eslint + prettier
├── rules/              # Modular development guidelines
│   ├── python.md             # Google style, type hints, uv
│   ├── react-vite.md         # Project structure, CSS Modules, Storybook
│   └── scientific-papers.md  # Paper structure, LaTeX, citations
└── skills/             # Personal skills for workflows
    ├── commit/
    ├── commit-push/
    ├── commit-pr/
    ├── fix/
    ├── lint/
    ├── proofread/
    └── secrets/
```

## Components

### Global Instructions (CLAUDE.md)
Contains global context and preferences:
- Communication style (concise, direct)
- Code style guidelines
- Gatekeeper rules (actions requiring confirmation)
- MCP tool recommendations

### Settings (settings.json)
Configuration file that controls:
- Permissions for automatic command execution
- Pre/post tool-use hooks
- Skill permissions

### Agents (agents/)
Specialized agents for the Task tool:
- **academic-publisher** - Venue selection and submission guidance
- **developer-frontend** - React + Vite UI/UX development
- **developer-backend** - API design and backend services
- **developer-reviewer** - Code review and quality assurance

### Commands (commands/)
Custom slash commands:
- `/latex-build` - Build LaTeX projects with pdflatex + bibtex

### Hooks (hooks/)
Automated scripts triggered by tool use:

**PreToolUse:**
- `block-secrets.sh` - Blocks access to sensitive files (env, credentials, keys)

**PostToolUse:**
- `python-test-lint.sh` - Auto-test and lint Python files (pytest, ruff)
- `js-test-lint.sh` - Auto-test and lint JS/TS/CSS files (npm test, eslint, prettier)

See `hooks/README.md` for detailed documentation.

### Rules (rules/)
Modular guidelines auto-loaded by Claude:
- `python.md` - Python coding standards (Google style, uv, type hints)
- `react-vite.md` - React + Vite development standards
- `scientific-papers.md` - Scientific paper writing standards

### Skills (skills/)
Reusable workflows for common tasks:
- `/commit` - Create conventional git commits
- `/commit-push` - Commit and push to remote
- `/commit-pr` - Commit, push, and create PR
- `/fix` - Interactive bug fixing workflow (Python/Node.js)
- `/lint` - Smart linting (detects project type)
- `/proofread` - Grammar, structure, notation proofreading
- `/secrets` - Audit codebase for secret handling issues

## How to Use

### Invoke a skill:
```
/commit
/fix
/lint
/secrets
/proofread
```

### Use an agent (via Task tool):
Claude automatically uses agents when appropriate, or you can request:
- "Review this code" → developer-reviewer agent
- "Help me build this React component" → developer-frontend agent
- "Where should I submit this paper?" → academic-publisher agent

### Reference rules in projects:
In a project's `.claude/CLAUDE.md`:
```markdown
@~/.claude/rules/python.md
```

## Customization

1. **Edit CLAUDE.md** to add personal context and preferences
2. **Create rules** for specific domains (e.g., `rules/data-science.md`)
3. **Build skills** for complex workflows
4. **Add agents** for specialized task handling
5. **Restart Claude Code** or start new session to load changes

## Tips

- Keep `CLAUDE.md` concise and high-level
- Use `rules/` for detailed, topic-specific guidelines
- Skills are ideal for complex, multi-step workflows
- Agents handle specialized domains with deep expertise
- Changes take effect in new sessions
