#!/bin/bash
# Gathers git information for commit analysis
# Usage: ./gather-git-info.sh [path]

set -e

REPO_PATH="${1:-.}"
cd "$REPO_PATH"

echo "=== Git Status ==="
git status

echo ""
echo "=== Staged Changes (git diff --cached) ==="
git diff --cached || echo "(no staged changes)"

echo ""
echo "=== Unstaged Changes (git diff) ==="
git diff || echo "(no unstaged changes)"

echo ""
echo "=== Untracked Files ==="
git ls-files --others --exclude-standard || echo "(none)"

echo ""
echo "=== Recent Commits (for style reference) ==="
git log --oneline -5 2>/dev/null || echo "(no commits yet)"

echo ""
echo "=== Current Branch ==="
git branch --show-current 2>/dev/null || echo "(detached HEAD or no commits)"
