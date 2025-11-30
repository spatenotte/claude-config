# Troubleshooting - Skill Activation Issues

Complete debugging guide for skill activation problems.

## Table of Contents

- [Skill Not Triggering](#skill-not-triggering)
- [False Positives](#false-positives)
- [Hook Not Executing](#hook-not-executing)
- [Performance Issues](#performance-issues)

---

## Skill Not Triggering

### UserPromptSubmit Not Suggesting

**Common Causes:**

#### 1. Keywords Don't Match

- Check `promptTriggers.keywords` in skill-rules.json
- Remember: case-insensitive substring matching
- Fix: Add more keyword variations

#### 2. Intent Patterns Too Specific

- Test regex at https://regex101.com/
- Fix: Broaden the pattern

#### 3. Typo in Skill Name

- Skill name in SKILL.md frontmatter must match skill-rules.json
- Fix: Make names match exactly

#### 4. JSON Syntax Error

```bash
cat .claude/skills/skill-rules.json | jq .
```

**Debug Command:**
```bash
echo '{"session_id":"debug","prompt":"your test prompt"}' | \
  npx tsx .claude/hooks/skill-activation-prompt.ts
```

### PreToolUse Not Blocking

**Common Causes:**

#### 1. File Path Doesn't Match Patterns

- Check glob patterns in `fileTriggers.pathPatterns`
- Fix: Adjust glob patterns

#### 2. Excluded by pathExclusions

- Check `fileTriggers.pathExclusions`
- Fix: Narrow exclusion or remove

#### 3. Content Pattern Not Found

- Check if file actually contains the pattern
- Debug: `grep -i "pattern" path/to/file.ts`

#### 4. Session Already Used Skill

```bash
cat .claude/hooks/state/skills-used-{session-id}.json
```
Fix: Delete state file to reset

#### 5. File Marker Present

```bash
grep "@skip-validation" path/to/file.ts
```

#### 6. Environment Variable Override

```bash
echo $SKIP_SKILL_GUARDRAILS
```
Fix: `unset SKIP_SKILL_GUARDRAILS`

**Debug Command:**
```bash
cat <<'EOF' | npx tsx .claude/hooks/skill-verification-guard.ts 2>&1
{
  "session_id": "debug",
  "tool_name": "Edit",
  "tool_input": {"file_path": "/path/to/file.ts"}
}
EOF
echo "Exit code: $?"
```

---

## False Positives

### Keywords Too Generic

**Problem:** `["user", "system", "create"]` matches too much

**Solution:** Make keywords more specific
```json
"keywords": ["user authentication", "user tracking"]
```

### Intent Patterns Too Broad

**Problem:** `(create)` matches everything with "create"

**Solution:** Add context
```json
"intentPatterns": ["(create|add).*?(database|table|feature)"]
```

### File Paths Too Generic

**Problem:** `form/**` matches everything

**Solution:** Narrow patterns
```json
"pathPatterns": ["form/src/services/**/*.ts"]
```

### Content Patterns Too Broad

**Problem:** `Prisma` matches comments and strings

**Solution:** Match specific patterns
```json
"contentPatterns": ["import.*[Pp]risma", "PrismaService\\."]
```

---

## Hook Not Executing

### 1. Hook Not Registered

Check `.claude/settings.json`:
```bash
cat .claude/settings.json | jq '.hooks'
```

### 2. Bash Wrapper Not Executable

```bash
chmod +x .claude/hooks/*.sh
```

### 3. Incorrect Shebang

First line must be: `#!/bin/bash`

### 4. npx/tsx Not Available

```bash
npx tsx --version
```
Fix: `cd .claude/hooks && npm install`

### 5. TypeScript Compilation Error

```bash
npx tsc --noEmit skill-activation-prompt.ts
```

---

## Performance Issues

### Too Many Patterns

- Count patterns in skill-rules.json
- Each pattern = regex compilation + matching
- Solution: Reduce and combine patterns

### Complex Regex

- Long alternations are slow
- Solution: Simplify patterns

### Too Many Files Checked

- `**/*.ts` checks ALL TypeScript files
- Solution: Use specific directory patterns

### Measure Performance

```bash
# UserPromptSubmit
time echo '{"prompt":"test"}' | npx tsx .claude/hooks/skill-activation-prompt.ts

# PreToolUse
time cat <<'EOF' | npx tsx .claude/hooks/skill-verification-guard.ts
{"tool_name":"Edit","tool_input":{"file_path":"test.ts"}}
EOF
```

**Target metrics:**
- UserPromptSubmit: < 100ms
- PreToolUse: < 200ms
