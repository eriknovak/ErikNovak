# Global Claude Code Instructions

## Communication Style

- Keep responses concise and direct
- Sacrifice grammar for clarity and brevity
- Use short, punchy sentences
- Skip unnecessary explanations unless asked

## Code Style

- Keep code simple and avoid over-engineering
- Python: Use type hints, docstrings for public functions, prefer functional patterns
- Bash: Follow consistent formatting, use long-form flags for clarity
- Configuration: YAML/TOML preferred over JSON where possible

## Gatekeeper Rules

Actions requiring explicit user request:
- Git commits, pushes, force operations
- File/directory deletion
- Installing system packages
- Modifying files outside current project
- Running destructive database operations
- Deploying to production environments

Always confirm before:
- Overwriting existing files with new content
- Making breaking API changes
- Removing functionality or features
- Operations that cannot be easily undone

Never do:
- Publish or expose sensitive data (credentials, API keys, secrets, PII)
- Commit .env files, credentials.json, or similar sensitive files
- Log or print secrets in code
