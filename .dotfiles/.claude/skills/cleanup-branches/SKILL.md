---
name: cleanup-branches
description: Remove local git branches that no longer exist on the remote repository. Use when the user wants to clean up stale branches, remove deleted branches, or says "cleanup branches" or "prune branches".
allowed-tools:
  - Bash(git:*)
---

# Git Branch Cleanup

This skill removes local branches that have been deleted from the remote repository, helping keep your local git repository clean and organized.

## What This Does

When branches are deleted on the remote (e.g., after merging a PR on GitHub), your local repository still keeps references to those branches. This skill:

1. Removes remote-tracking branches that no longer exist on the remote (`git fetch --prune`)
2. Identifies local branches whose remote counterpart has been deleted
3. Safely deletes those local branches (with user confirmation)
4. Protects important branches (main, master, develop) from deletion

## Workflow

1. **Fetch and prune remote references**:
   ```bash
   git fetch --prune
   ```
   This updates your remote-tracking branches and removes references to deleted remote branches.

2. **Identify branches to delete**:
   ```bash
   git branch -vv
   ```
   Look for branches marked as `[origin/branch: gone]` - these are local branches whose remote counterpart has been deleted.

3. **List branches for confirmation**:
   - Show the user which branches will be deleted
   - Exclude protected branches (main, master, develop, current branch)
   - Show when each branch was last modified if possible

4. **Get user confirmation**:
   - Present the list of branches to delete
   - Ask user to confirm before deletion
   - Allow user to exclude specific branches

5. **Delete branches**:
   ```bash
   git branch -d <branch-name>
   ```
   Use `-d` (safe delete) which prevents deleting unmerged branches.
   If user wants to force delete unmerged branches, use `-D`.

6. **Report results**:
   - Show which branches were deleted
   - Show any branches that couldn't be deleted (e.g., unmerged changes)
   - Provide summary of cleanup

## Commands Used

```bash
# Update remote references and prune deleted ones
git fetch --prune

# List all branches with their tracking status
git branch -vv

# Check if a branch is merged
git branch --merged

# Safe delete (only if merged)
git branch -d <branch-name>

# Force delete (even if unmerged) - use with caution
git branch -D <branch-name>
```

## Protected Branches

Never delete these branches automatically:
- `main`
- `master`
- `develop`
- `development`
- `staging`
- `production`
- Current checked-out branch

## Examples

### Basic Cleanup

```bash
# Prune remote references
$ git fetch --prune
From github.com:user/repo
 - [deleted]         (none)     -> origin/feature/old-feature
 - [deleted]         (none)     -> origin/bugfix/old-bug

# List branches with gone remotes
$ git branch -vv
  feature/old-feature   abc1234 [origin/feature/old-feature: gone] Old feature
  feature/current       def5678 [origin/feature/current] Current work
* main                  ghi9012 [origin/main] Latest changes

# Delete gone branches
$ git branch -d feature/old-feature
Deleted branch feature/old-feature (was abc1234).
```

### Automated Script

Here's what the skill does automatically:

```bash
# Fetch and prune
git fetch --prune

# Find branches with gone remotes
gone_branches=$(git branch -vv | grep ': gone]' | awk '{print $1}')

# Filter out protected branches and current branch
current_branch=$(git branch --show-current)
protected_branches="main master develop development staging production"

# Show branches to delete and confirm
echo "The following branches will be deleted:"
for branch in $gone_branches; do
  if [[ ! "$protected_branches" =~ "$branch" ]] && [[ "$branch" != "$current_branch" ]]; then
    echo "  - $branch"
  fi
done

# After confirmation, delete each branch
for branch in $gone_branches; do
  if [[ ! "$protected_branches" =~ "$branch" ]] && [[ "$branch" != "$current_branch" ]]; then
    git branch -d "$branch"
  fi
done
```

## Safety Features

1. **Always fetch first**: Ensures we have latest remote information before making decisions
2. **Use `-d` not `-D`**: Safe delete prevents accidental deletion of unmerged work
3. **Protect important branches**: Never auto-delete main/master/develop
4. **Confirm before deletion**: Show list and get user approval
5. **Report unmerged branches**: If a branch can't be deleted, explain why

## Handling Unmerged Branches

If `git branch -d` fails because a branch has unmerged changes:

```
error: The branch 'feature/old' is not fully merged.
```

**Options**:
1. Check if the changes are important: `git log origin/main..feature/old`
2. If changes are important, merge or rebase them first
3. If changes are not needed, force delete with `-D`: `git branch -D feature/old`

Ask the user what they want to do with each unmerged branch.

## Additional Cleanup Options

Can also offer to:
- Delete all merged local branches: `git branch --merged | grep -v "\\*" | grep -v main | grep -v master | xargs -n 1 git branch -d`
- List branches by last commit date: `git branch -v --sort=-committerdate`
- Find branches not pushed to remote: `git branch -vv | grep -v origin`

## Important Notes

- **Backup important work**: Always ensure important work is pushed to remote before cleanup
- **Check unmerged carefully**: Unmerged branches might contain important unpushed work
- **Run regularly**: Regular cleanup keeps your repository tidy
- **Team coordination**: Be aware of team members' local branches before deleting shared work
