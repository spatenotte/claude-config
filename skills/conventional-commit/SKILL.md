---
name: conventional-commit
description: Create well-formatted git commits following the Conventional Commits spec. Use when asked to commit, create a commit, or commit changes. Handles the full workflow including analyzing changes, splitting into logical commits, drafting messages, and creating commits with proper attribution.
---

# Conventional Commit Workflow

## Quick Reference

| Type | Description |
|------|-------------|
| feat | New feature |
| fix | Bug fix |
| docs | Documentation only |
| refactor | Code change that neither fixes nor adds |
| test | Adding or updating tests |
| chore | Tooling, config, dependencies |
| style | Formatting, whitespace |
| perf | Performance improvement |
| ci | CI/CD changes |
| build | Build system changes |

## Workflow

### Step 1: Gather Information

Run these commands in parallel:
```bash
git status
git diff --cached
git diff
git log --oneline -5
```

### Step 2: Analyze for Commit Splitting

Before drafting, determine if changes should be split into multiple commits.

**Split when you find:**
- Different concerns (unrelated parts of codebase)
- Different change types (mixing feat + fix + refactor)
- Different file patterns (source code vs docs vs tests)
- Logically separable changes (easier to review separately)
- Large changesets that benefit from breakdown

**Keep together when:**
- Changes are tightly coupled
- One change necessitates another
- Splitting would create broken intermediate states

If splitting: process each logical group as a separate commit, starting with foundational changes.

### Step 3: Stage Files

- If files already staged, use those
- If nothing staged, stage files for the current logical commit group
- **Never stage**: `.env`, `credentials.json`, `*_secret*`, API keys, tokens

### Step 4: Draft Commit Message

Format:
```
<type>(<scope>): <description>

[optional body explaining why, not what]

🤖 Generated with [Claude Code](https://claude.ai/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

Rules:
- First line under 72 characters
- Use present tense, imperative mood ("add" not "added")
- Scope is optional, derive from primary directory/component
- Body explains motivation if non-obvious
- Use HEREDOC for the commit command

### Step 5: Create Commit

```bash
git commit -m "$(cat <<'EOF'
<type>(<scope>): <description>

[body]

🤖 Generated with [Claude Code](https://claude.ai/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Step 6: Handle Pre-commit Hooks

If commit fails due to pre-commit hook modifications:
1. Check what changed: `git diff`
2. Stage the hook's changes: `git add -u`
3. Retry commit with `--amend` (only if this is your own commit)

Before amending, verify:
```bash
git log -1 --format='%an %ae'  # Must be Claude's commit
git status                      # Must show "ahead of" remote
```

### Step 7: Verify

Run `git status` to confirm clean working tree or remaining changes.

If you split commits, repeat Steps 3-7 for each logical group.

## Constraints

- **No secrets**: Warn and exclude sensitive files
- **No empty commits**: Verify changes exist before committing
- **No --amend** unless: fixing pre-commit hook changes OR explicitly requested
- **No --force push**: Never include push commands unless asked
- **No -i flags**: Interactive git commands are not supported
- **Check authorship**: Always verify before amending

## Reference

See `references/conventional-commits.md` for the full type definitions and examples.
