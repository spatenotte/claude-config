# skill-rules.json Complete Reference

The `skill-rules.json` configuration file defines skills and their activation triggers.

## Table of Contents

- [Core Structure](#core-structure)
- [Skill Rule Schema](#skill-rule-schema)
- [Guardrail Skill Example](#guardrail-skill-example)
- [Domain Skill Example](#domain-skill-example)
- [Validation](#validation)

---

## Core Structure

```json
{
  "version": "1.0",
  "skills": {
    "skill-name": { /* SkillRule */ },
    "another-skill": { /* SkillRule */ }
  }
}
```

---

## Skill Rule Schema

```typescript
interface SkillRule {
  // Required
  type: "guardrail" | "domain";
  enforcement: "block" | "suggest" | "warn";
  priority: "critical" | "high" | "medium" | "low";

  // Optional - Prompt-based triggers
  promptTriggers?: {
    keywords?: string[];        // Case-insensitive substring match
    intentPatterns?: string[];  // Regex patterns
  };

  // Optional - File-based triggers (PreToolUse)
  fileTriggers?: {
    pathPatterns?: string[];    // Glob patterns
    pathExclusions?: string[];  // Glob patterns to exclude
    contentPatterns?: string[]; // Regex patterns in file content
  };

  // Required for guardrails
  blockMessage?: string;        // Message shown when blocked

  // Optional - Skip conditions
  skipConditions?: {
    sessionTracking?: boolean;  // Don't repeat in same session
    fileMarkers?: string[];     // Comments that disable check
    envVars?: string[];         // Env vars that disable check
  };
}
```

---

## Guardrail Skill Example

```json
{
  "database-verification": {
    "type": "guardrail",
    "enforcement": "block",
    "priority": "critical",
    "promptTriggers": {
      "keywords": ["prisma", "database", "migration"],
      "intentPatterns": [
        "(add|create|modify).*?(table|column|field)",
        "(query|fetch|update).*?database"
      ]
    },
    "fileTriggers": {
      "pathPatterns": [
        "**/services/**/*.ts",
        "**/controllers/**/*.ts"
      ],
      "pathExclusions": [
        "**/*.test.ts",
        "**/*.spec.ts"
      ],
      "contentPatterns": [
        "import.*[Pp]risma",
        "PrismaService",
        "\\.findMany\\(",
        "\\.create\\(",
        "\\.update\\(",
        "\\.delete\\("
      ]
    },
    "blockMessage": "Database operation detected. Use 'database-verification' skill to verify table/column names before proceeding.",
    "skipConditions": {
      "sessionTracking": true,
      "fileMarkers": ["@skip-validation", "@verified"],
      "envVars": ["SKIP_DB_VERIFICATION"]
    }
  }
}
```

---

## Domain Skill Example

```json
{
  "frontend-dev-guidelines": {
    "type": "domain",
    "enforcement": "suggest",
    "priority": "high",
    "promptTriggers": {
      "keywords": [
        "react",
        "component",
        "frontend",
        "UI",
        "styling",
        "MUI"
      ],
      "intentPatterns": [
        "(create|add|build).*?(component|page|modal)",
        "(style|design).*?(UI|interface)"
      ]
    },
    "fileTriggers": {
      "pathPatterns": [
        "frontend/src/**/*.tsx",
        "frontend/src/**/*.ts"
      ],
      "pathExclusions": [
        "**/*.test.tsx",
        "**/*.stories.tsx"
      ]
    }
  }
}
```

---

## Validation

Always validate JSON syntax before deployment:

```bash
cat .claude/skills/skill-rules.json | jq .
```

### Common Errors

- **Trailing commas**: JSON doesn't allow trailing commas
- **Single quotes**: Must use double quotes
- **Unescaped backslashes**: Use `\\` in regex patterns
- **Missing required fields**: type, enforcement, priority are required
- **Invalid enum values**: Check spelling of type/enforcement/priority
