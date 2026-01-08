---
name: commit-push
description: Create a conventional commit and push it to the remote repository. Use when the user wants to commit changes and immediately push them, or says "commit and push" or "push my changes".
user-invocable: true
allowed-tools:
  - Read
  - Bash(git:*)
  - Grep
  - Glob
---

# Git Commit and Push

This skill creates a commit following the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification and pushes it to the remote repository.

## Workflow

1. **Check repository state**: Run git status -sb to see:
   - Current branch name
   - Whether branch tracks a remote
   - What files are modified/staged
   - How far ahead/behind the remote we are

2. **Review changes**: Run git diff or git diff --staged to see what will be committed

3. **Stage files if needed**: If no files are staged, ask which files to stage or stage relevant files

4. **Create commit**: Follow the same process as the commit skill:
   - Analyze changes to determine type (feat, fix, chore, etc.)
   - Determine optional scope
   - Write clear description in imperative mood
   - Add body/footers if needed
   - Show proposed message for approval
   - Create commit using git commit

5. **Check remote tracking**:
   - If branch tracks a remote: use git push
   - If branch is new/untracked: use git push -u origin <branch-name>

6. **Push to remote**: Execute the appropriate push command

7. **Confirm success**: Show the result and confirm the push succeeded

## Commit Message Format

Follow Conventional Commits specification:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types**: feat, fix, docs, style, refactor, perf, test, build, ci, chore

See the commit skill for detailed commit message guidelines.

## Examples

```bash
# Check status
git status -sb

# Review changes
git diff --staged

# Commit with conventional format
git commit -m "feat(tmux): add new key bindings for window management"

# Push to remote
git push
```

## Important Notes

- **Always review before pushing**: Show the commit message and ask for approval before pushing
- **Check remote status**: Verify whether branch tracks a remote before pushing
- **Handle conflicts**: If push is rejected (e.g., remote has changes), inform user and suggest pulling first
- **Use -u flag for new branches**: When pushing a new branch, use git push -u origin <branch>
- **Respect git config**: Use user's aliases from ~/.gitconfig when appropriate
- **No attribution**: Do NOT include "Generated with Claude Code" or "Co-Authored-By" lines in commit messages

## Error Handling

- **Push rejected**: If remote has changes, suggest git pull --rebase then push again
- **No remote**: If repository has no remote, inform user and skip push
- **Authentication issues**: If push fails due to auth, provide clear error message
- **Already up to date**: If no changes to push, inform user the remote is already current
