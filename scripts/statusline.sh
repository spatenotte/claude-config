#!/bin/bash
# Simple statusline for Claude Code
# Reads JSON from stdin, outputs formatted status

# Colors (ANSI)
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
BLUE='\033[34m'
GREEN='\033[32m'
YELLOW='\033[33m'
CYAN='\033[36m'
MAGENTA='\033[35m'

# Read JSON from stdin
if [ -t 0 ]; then
    # No stdin, exit silently
    exit 0
fi

INPUT=$(cat)

# Check if jq is available
if ! command -v jq &> /dev/null; then
    # Fallback: no jq, just show a simple indicator
    echo -e "${RESET}${BLUE}Claude Code${RESET}"
    exit 0
fi

# Parse JSON fields
MODEL=$(echo "$INPUT" | jq -r '.model.display_name // .model.id // "unknown"' 2>/dev/null)
CWD=$(echo "$INPUT" | jq -r '.workspace.current_dir // .cwd // ""' 2>/dev/null)
COST=$(echo "$INPUT" | jq -r '.cost.total_cost_usd // 0' 2>/dev/null)
DURATION_MS=$(echo "$INPUT" | jq -r '.cost.total_duration_ms // 0' 2>/dev/null)

# Format cost
if [ "$COST" != "0" ] && [ "$COST" != "null" ]; then
    COST_FMT=$(printf '$%.4f' "$COST")
else
    COST_FMT=""
fi

# Format duration (ms to minutes:seconds)
if [ "$DURATION_MS" != "0" ] && [ "$DURATION_MS" != "null" ]; then
    DURATION_SEC=$((DURATION_MS / 1000))
    DURATION_MIN=$((DURATION_SEC / 60))
    DURATION_SEC_REM=$((DURATION_SEC % 60))
    DURATION_FMT=$(printf '%d:%02d' "$DURATION_MIN" "$DURATION_SEC_REM")
else
    DURATION_FMT=""
fi

# Get git branch if in a git repo
GIT_BRANCH=""
if command -v git &> /dev/null && [ -n "$CWD" ]; then
    GIT_BRANCH=$(git -C "$CWD" branch --show-current 2>/dev/null)
fi

# Get last 2 path segments
if [ -n "$CWD" ]; then
    DIR_SHORT=$(echo "$CWD" | rev | cut -d'/' -f1-2 | rev)
else
    DIR_SHORT=""
fi

# Build output
OUTPUT=""

# Model
if [ -n "$MODEL" ] && [ "$MODEL" != "unknown" ] && [ "$MODEL" != "null" ]; then
    OUTPUT="${RESET}${BOLD}${MAGENTA}${MODEL}${RESET}"
fi

# Git branch
if [ -n "$GIT_BRANCH" ]; then
    [ -n "$OUTPUT" ] && OUTPUT="$OUTPUT ${DIM}│${RESET} "
    OUTPUT="${OUTPUT}${CYAN} ${GIT_BRANCH}${RESET}"
fi

# Directory
if [ -n "$DIR_SHORT" ]; then
    [ -n "$OUTPUT" ] && OUTPUT="$OUTPUT ${DIM}│${RESET} "
    OUTPUT="${OUTPUT}${BLUE}${DIR_SHORT}${RESET}"
fi

# Cost
if [ -n "$COST_FMT" ]; then
    [ -n "$OUTPUT" ] && OUTPUT="$OUTPUT ${DIM}│${RESET} "
    OUTPUT="${OUTPUT}${GREEN}${COST_FMT}${RESET}"
fi

# Duration
if [ -n "$DURATION_FMT" ]; then
    [ -n "$OUTPUT" ] && OUTPUT="$OUTPUT ${DIM}│${RESET} "
    OUTPUT="${OUTPUT}${YELLOW}${DURATION_FMT}${RESET}"
fi

# Output with reset prefix (to override Claude Code's dim styling)
echo -e "${RESET}${OUTPUT}"
