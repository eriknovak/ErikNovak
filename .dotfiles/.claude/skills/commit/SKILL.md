---
name: commit
description: Create a git commit with a conventional commit message. Use when the user wants to commit changes, stage and commit, or needs help writing a commit message following conventional commits format (feat, fix, chore, docs, style, refactor, perf, test, build, ci).
allowed-tools:
  - Read
  - Bash(git:*)
  - Grep
  - Glob
---

# Git Commit with Conventional Commits

This skill helps you create well-formatted git commits following the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification.

## Commit Message Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Commit Types

- **feat:** A new feature (correlates to MINOR in semantic versioning)
- **fix:** A bug fix (correlates to PATCH in semantic versioning)
- **docs:** Documentation only changes
- **style:** Changes that don't affect code meaning (formatting, whitespace, etc.)
- **refactor:** Code change that neither fixes a bug nor adds a feature
- **perf:** Performance improvement
- **test:** Adding or modifying tests
- **build:** Changes to build system or dependencies
- **ci:** Changes to CI configuration files and scripts
- **chore:** Other changes that don't modify src or test files

## Breaking Changes

- Add `!` after type/scope: `feat!: description` or `feat(api)!: description`
- Or add footer: `BREAKING CHANGE: description of the breaking change`

## Workflow

1. **Check current status**: Run `git status -sb` to see what files are modified
2. **Review changes**: Run `git diff` for unstaged changes or `git diff --staged` for staged changes
3. **Stage files if needed**: If files aren't staged, ask the user which files to stage or stage all relevant files
4. **Analyze changes**: Read the diff to understand what changed
5. **Determine commit type**: Based on the changes, select the appropriate type:
   - New functionality → `feat:`
   - Bug fixes → `fix:`
   - Documentation → `docs:`
   - Refactoring → `refactor:`
   - Tests → `test:`
   - Configuration/dotfiles updates → `chore:`
   - Performance improvements → `perf:`
6. **Determine scope** (optional): If changes are focused on a specific component, add scope in parentheses
7. **Write description**: Clear, concise description in imperative mood (e.g., "add feature" not "added feature")
8. **Add body if needed**: For complex changes, add a body explaining what and why (not how)
9. **Add footers if needed**: For breaking changes or issue references
10. **Show the commit message**: Present the proposed commit message to the user for review
11. **Create commit**: Use `git commit` with the approved message

## Examples

```
feat(auth): add OAuth2 login support

Implement OAuth2 authentication flow with Google and GitHub providers.
Users can now sign in using their existing accounts.

Closes #123
```

```
fix: resolve memory leak in connection pool

The connection pool was not properly releasing connections after use,
causing memory usage to grow over time.
```

```
chore(dotfiles): update tmux configuration

Add new key bindings and update theme to Catppuccin.
```

```
feat!: change API response format to JSON:API spec

BREAKING CHANGE: All API endpoints now return responses following the
JSON:API specification. Clients will need to update their response parsing.
```

## Important Notes

- **Description format**: Use imperative mood, lowercase, no period at the end
- **Character limits**: Keep the first line under 72 characters
- **Scope**: Use lowercase, keep it short (e.g., `api`, `auth`, `ui`, `parser`)
- **Body**: Wrap at 72 characters, separate from description with blank line
- **User's git config**: Respect aliases from `~/.gitconfig` (e.g., `g` for git, `st` for status)

## Handling Edge Cases

- If no files are staged and no changes exist, inform the user there's nothing to commit
- If the change is very simple (typo, whitespace), keep the commit message concise
- For multi-component changes, suggest breaking into multiple commits or use a general scope
- Always show the proposed commit message before committing for user approval
