# Trigger Types - Complete Guide

Complete reference for configuring skill triggers in Claude Code's skill auto-activation system.

## Table of Contents

- [Keyword Triggers](#keyword-triggers)
- [Intent Pattern Triggers](#intent-pattern-triggers)
- [File Path Triggers](#file-path-triggers)
- [Content Pattern Triggers](#content-pattern-triggers)
- [Best Practices Summary](#best-practices-summary)

---

## Keyword Triggers

### How It Works

Case-insensitive substring matching in user's prompt.

### Use For

Topic-based activation where user explicitly mentions the subject.

### Configuration

```json
"promptTriggers": {
  "keywords": ["layout", "grid", "toolbar", "submission"]
}
```

### Best Practices

- Use specific, unambiguous terms
- Include common variations ("layout", "layout system", "grid layout")
- Avoid overly generic words ("system", "work", "create")
- Test with real prompts

---

## Intent Pattern Triggers

### How It Works

Regex pattern matching to detect user's intent even when they don't mention the topic explicitly.

### Use For

Action-based activation where user describes what they want to do rather than the specific topic.

### Configuration

```json
"promptTriggers": {
  "intentPatterns": [
    "(create|add|implement).*?(feature|endpoint)",
    "(how does|explain).*?(layout|workflow)"
  ]
}
```

### Best Practices

- Capture common action verbs: `(create|add|modify|build|implement)`
- Include domain-specific nouns: `(feature|endpoint|component|workflow)`
- Use non-greedy matching: `.*?` instead of `.*`
- Test patterns thoroughly with regex tester (https://regex101.com/)
- Don't make patterns too broad (causes false positives)
- Don't make patterns too specific (causes false negatives)

### Common Pattern Examples

```regex
# Database Work
(add|create|implement).*?(user|login|auth|feature)

# Explanations
(how does|explain|what is|describe).*?

# Frontend Work
(create|add|make|build).*?(component|UI|page|modal|dialog)

# Error Handling
(fix|handle|catch|debug).*?(error|exception|bug)

# Workflow Operations
(create|add|modify).*?(workflow|step|branch|condition)
```

---

## File Path Triggers

### How It Works

Glob pattern matching against the file path being edited.

### Use For

Domain/area-specific activation based on file location in the project.

### Configuration

```json
"fileTriggers": {
  "pathPatterns": [
    "frontend/src/**/*.tsx",
    "form/src/**/*.ts"
  ],
  "pathExclusions": [
    "**/*.test.ts",
    "**/*.spec.ts"
  ]
}
```

### Glob Pattern Syntax

- `**` = Any number of directories (including zero)
- `*` = Any characters within a directory name
- Examples:
  - `frontend/src/**/*.tsx` = All .tsx files in frontend/src and subdirs
  - `**/schema.prisma` = schema.prisma anywhere in project
  - `form/src/**/*.ts` = All .ts files in form/src subdirs

### Best Practices

- Be specific to avoid false positives
- Use exclusions for test files: `**/*.test.ts`
- Consider subdirectory structure
- Test patterns with actual file paths
- Use narrower patterns when possible

---

## Content Pattern Triggers

### How It Works

Regex pattern matching against the file's actual content.

### Use For

Technology-specific activation based on what the code imports or uses.

### Configuration

```json
"fileTriggers": {
  "contentPatterns": [
    "import.*[Pp]risma",
    "PrismaService",
    "\\.findMany\\(",
    "\\.create\\("
  ]
}
```

### Best Practices

- Match imports: `import.*[Pp]risma` (case-insensitive with [Pp])
- Escape special regex chars: `\\.findMany\\(` not `.findMany(`
- Patterns use case-insensitive flag
- Test against real file content
- Make patterns specific enough to avoid false matches

### Common Content Patterns

```regex
# Prisma/Database
import.*[Pp]risma                # Prisma imports
PrismaService                    # PrismaService usage
\.findMany\(                     # Prisma query methods

# Controllers/Routes
export class.*Controller         # Controller classes
router\.                         # Express router
app\.(get|post|put|delete|patch) # Express app routes

# React/Components
export.*React\.FC               # React functional components
useState|useEffect              # React hooks
```

---

## Best Practices Summary

### DO:
- Use specific, unambiguous keywords
- Test all patterns with real examples
- Include common variations
- Use non-greedy regex: `.*?`
- Escape special characters in content patterns
- Add exclusions for test files
- Make file path patterns narrow and specific

### DON'T:
- Use overly generic keywords ("system", "work")
- Make intent patterns too broad (false positives)
- Make patterns too specific (false negatives)
- Forget to test with regex tester
- Use greedy regex: `.*` instead of `.*?`
- Match too broadly in file paths

### Testing Your Triggers

**Test keyword/intent triggers:**
```bash
echo '{"session_id":"test","prompt":"your test prompt"}' | \
  npx tsx .claude/hooks/skill-activation-prompt.ts
```

**Test file path/content triggers:**
```bash
cat <<'EOF' | npx tsx .claude/hooks/skill-verification-guard.ts
{
  "session_id": "test",
  "tool_name": "Edit",
  "tool_input": {"file_path": "/path/to/test/file.ts"}
}
EOF
```
