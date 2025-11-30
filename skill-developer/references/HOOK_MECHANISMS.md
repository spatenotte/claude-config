# Hook Mechanisms - Deep Dive

Technical deep dive into how the UserPromptSubmit and PreToolUse hooks work.

## Table of Contents

- [UserPromptSubmit Hook Flow](#userpromptsubmit-hook-flow)
- [PreToolUse Hook Flow](#pretooluse-hook-flow)
- [Exit Code Behavior](#exit-code-behavior)
- [Session State Management](#session-state-management)
- [Performance Considerations](#performance-considerations)

---

## UserPromptSubmit Hook Flow

### Execution Sequence

```
User submits prompt
    |
.claude/settings.json registers hook
    |
skill-activation-prompt.sh executes
    |
npx tsx skill-activation-prompt.ts
    |
Hook reads stdin (JSON with prompt)
    |
Loads skill-rules.json
    |
Matches keywords + intent patterns
    |
Groups matches by priority
    |
Outputs formatted message to stdout
    |
stdout becomes context for Claude
    |
Claude sees: [skill suggestion] + user's prompt
```

### Key Points

- **Exit code**: Always 0 (allow)
- **stdout**: Injected as context for Claude
- **Timing**: Runs BEFORE Claude processes prompt
- **Behavior**: Non-blocking, advisory only
- **Purpose**: Make Claude aware of relevant skills

### Input Format

```json
{
  "session_id": "abc-123",
  "transcript_path": "/path/to/transcript.json",
  "cwd": "/root/git/your-project",
  "permission_mode": "normal",
  "hook_event_name": "UserPromptSubmit",
  "prompt": "how does the layout system work?"
}
```

---

## PreToolUse Hook Flow

### Execution Sequence

```
Claude calls Edit/Write tool
    |
.claude/settings.json registers hook (matcher: Edit|Write)
    |
skill-verification-guard.sh executes
    |
Hook reads stdin (JSON with tool_name, tool_input)
    |
Loads skill-rules.json
    |
Checks file path patterns (glob matching)
    |
Reads file for content patterns (if file exists)
    |
Checks session state (was skill already used?)
    |
Checks skip conditions (file markers, env vars)
    |
IF MATCHED AND NOT SKIPPED:
  Update session state
  Output block message to stderr
  Exit with code 2 (BLOCK)
ELSE:
  Exit with code 0 (ALLOW)
```

### Key Points

- **Exit code 2**: BLOCK (stderr sent to Claude)
- **Exit code 0**: ALLOW
- **Timing**: Runs BEFORE tool execution
- **Session tracking**: Prevents repeated blocks in same session
- **Fail open**: On errors, allows operation

### Input Format

```json
{
  "session_id": "abc-123",
  "tool_name": "Edit",
  "tool_input": {
    "file_path": "/path/to/file.ts",
    "old_string": "...",
    "new_string": "..."
  }
}
```

---

## Exit Code Behavior

### Exit Code Reference Table

| Exit Code | stdout | stderr | Tool Execution | Claude Sees |
|-----------|--------|--------|----------------|-------------|
| 0 (UserPromptSubmit) | Context | User only | N/A | stdout content |
| 0 (PreToolUse) | User only | User only | **Proceeds** | Nothing |
| 2 (PreToolUse) | User only | **CLAUDE** | **BLOCKED** | stderr content |
| Other | User only | User only | Blocked | Nothing |

### Why Exit Code 2 Matters

This is THE critical mechanism for enforcement:

1. **Only way** to send message to Claude from PreToolUse
2. stderr content is fed back to Claude automatically
3. Claude sees the block message and understands what to do
4. Tool execution is prevented
5. Critical for enforcement of guardrails

---

## Session State Management

### Purpose

Prevent repeated nagging in the same session - once Claude uses a skill, don't block again.

### State File Location

`.claude/hooks/state/skills-used-{session_id}.json`

### State File Structure

```json
{
  "skills_used": [
    "database-verification",
    "error-tracking"
  ],
  "files_verified": []
}
```

### How It Works

1. **First edit** triggers block, updates session state
2. **Second edit** (same session) checks state, allows
3. **Different session** has new state file, blocks again

---

## Performance Considerations

### Target Metrics

- **UserPromptSubmit**: < 100ms
- **PreToolUse**: < 200ms

### Optimization Strategies

**Reduce patterns:**
- Use more specific patterns (fewer to check)
- Combine similar patterns where possible

**File path patterns:**
- More specific = fewer files to check
- Example: `form/src/services/**` better than `form/**`

**Content patterns:**
- Only add when truly necessary
- Simpler regex = faster matching

### Measure Performance

```bash
# UserPromptSubmit
time echo '{"prompt":"test"}' | npx tsx .claude/hooks/skill-activation-prompt.ts

# PreToolUse
time cat <<'EOF' | npx tsx .claude/hooks/skill-verification-guard.ts
{"tool_name":"Edit","tool_input":{"file_path":"test.ts"}}
EOF
```
