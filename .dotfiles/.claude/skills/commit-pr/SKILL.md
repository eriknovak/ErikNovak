---
name: commit-pr
description: Create a conventional commit, push to remote, and create a pull request. Use when the user wants to commit, push, and create a PR in one go, or says "commit and create PR" or "make a pull request".
allowed-tools:
  - Read
  - Bash(git:*)
  - Bash(gh:*)
  - Grep
  - Glob
---

# Git Commit, Push, and Create Pull Request

This skill creates a commit following [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/), pushes to remote, and creates a pull request using GitHub CLI (`gh`).

## Prerequisites

- GitHub CLI (`gh`) must be installed and authenticated
- Repository must have a GitHub remote
- User must have push access to the repository

## Workflow

1. **Check repository state**:
   - Run `git status -sb` to see current branch and changes
   - Verify we're not on main/master branch (don't create PR from main)
   - Check if remote exists and is a GitHub repository

2. **Review changes**:
   - Run `git diff` or `git diff --staged` to see what will be committed
   - Check `git log origin/main..HEAD` to see existing commits on the branch

3. **Stage files if needed**: If no files are staged, ask which files to stage

4. **Create commit**:
   - Analyze changes to determine type (feat, fix, chore, etc.)
   - Write conventional commit message
   - Show proposed message for approval
   - Create commit using `git commit`

5. **Push to remote**:
   - Check if branch tracks a remote
   - Use `git push` or `git push -u origin <branch>` for new branches
   - Verify push succeeded

6. **Create pull request**:
   - Determine base branch (usually main/master)
   - Generate PR title from commit message(s)
   - Create PR body with:
     - Summary of changes
     - List of commits if multiple
     - Any relevant context
   - Use `gh pr create --title "..." --body "..."`
   - Optionally add labels, reviewers, etc.

7. **Show result**: Display the PR URL and confirm success

## Commit Message Format

Follow Conventional Commits specification:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`

## Pull Request Format

**Title**: Use the commit message description (or summarize if multiple commits)

**Body**:
```markdown
## Summary
Brief description of what this PR does

## Changes
- List of key changes
- From commit messages

## Type
feat/fix/chore/etc (from conventional commit type)

Closes #issue-number (if applicable)
```

## Examples

### Single Commit PR

```bash
# Check status
git status -sb

# Stage and commit
git add .
git commit -m "feat(auth): add password reset functionality"

# Push
git push -u origin feature/password-reset

# Create PR
gh pr create \
  --title "feat(auth): add password reset functionality" \
  --body "## Summary
Add password reset functionality with email verification.

## Changes
- Add password reset endpoint
- Implement email verification flow
- Add password reset UI components

## Type
feat"
```

### Multiple Commits PR

```bash
# If branch has multiple commits, summarize them
gh pr create \
  --title "feat(dashboard): improve user dashboard" \
  --body "## Summary
Multiple improvements to user dashboard.

## Changes
- feat(dashboard): add data visualization widgets
- fix(dashboard): resolve loading state issues
- refactor(dashboard): improve component structure

## Type
feat"
```

## Important Notes

- **Branch check**: Never create PR from main/master branch
- **GitHub CLI**: Verify `gh` is installed with `gh --version`
- **Authentication**: Check `gh auth status` if PR creation fails
- **Base branch**: Default to main, but check the repository's default branch
- **Draft PRs**: Can add `--draft` flag if changes aren't ready for review
- **Labels**: Can add `--label` flag if repository uses labels
- **Reviewers**: Can add `--reviewer` flag to request reviews

## Error Handling

- **Not on GitHub**: If remote is not GitHub, inform user and skip PR creation
- **On main branch**: Warn user and suggest creating a feature branch first
- **No commits**: If branch has no new commits vs main, inform user nothing to PR
- **gh not installed**: Provide installation instructions
- **Not authenticated**: Run `gh auth login` to authenticate
- **Push fails**: Fix push issues before attempting PR creation
- **PR already exists**: If PR exists for branch, show existing PR URL

## Advanced Options

Can extend the `gh pr create` command with:
- `--draft`: Create draft PR
- `--label <label>`: Add labels
- `--reviewer <username>`: Request reviews
- `--assignee <username>`: Assign PR
- `--milestone <name>`: Add to milestone
- `--base <branch>`: Specify base branch (if not main)
