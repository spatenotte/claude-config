# Common Patterns Library

Ready-to-use regex and glob patterns for skill triggers.

## Table of Contents

- [Intent Patterns](#intent-patterns)
- [File Path Patterns](#file-path-patterns)
- [Content Patterns](#content-patterns)

---

## Intent Patterns

### Feature/Endpoint Creation

```regex
(add|create|implement|build).*?(feature|endpoint|route|service|controller)
```

### Component Building

```regex
(create|add|make|build).*?(component|UI|page|modal|dialog|form)
```

### Database Operations

```regex
(add|create|modify|update).*?(table|column|field|migration|schema)
(query|fetch|update|delete).*?database
```

### Error Handling

```regex
(fix|handle|catch|debug).*?(error|exception|bug|issue)
```

### Explanations

```regex
(how does|explain|what is|describe|show me).*?
```

### Workflow Operations

```regex
(create|add|modify).*?(workflow|step|branch|condition)
```

### Testing

```regex
(write|add|create).*?(test|spec|unit test|integration test)
```

---

## File Path Patterns

### Frontend

```glob
frontend/src/**/*.tsx        # All React components
frontend/src/**/*.ts         # All TypeScript files
frontend/src/components/**   # Only components directory
```

### Backend Services

```glob
**/services/**/*.ts          # Service files
**/controllers/**/*.ts       # Controller files
**/routes/**/*.ts            # Route files
```

### Database

```glob
**/schema.prisma             # Prisma schema (anywhere)
**/migrations/**/*.sql       # Migration files
**/models/**/*.ts            # Model files
```

### Test Exclusions

```glob
**/*.test.ts                 # TypeScript tests
**/*.test.tsx                # React component tests
**/*.spec.ts                 # Spec files
**/__tests__/**              # Test directories
```

---

## Content Patterns

### Prisma/Database

```regex
import.*[Pp]risma           # Prisma imports
PrismaService               # PrismaService usage
prisma\.                    # prisma.something
\.findMany\(                # Prisma query methods
\.create\(
\.update\(
\.delete\(
\.findUnique\(
\.findFirst\(
```

### Controllers/Routes

```regex
export class.*Controller    # Controller classes
@Controller\(               # NestJS controller decorator
router\.                    # Express router
app\.(get|post|put|delete|patch)\(  # Express routes
```

### Error Handling

```regex
try\s*\{                    # Try blocks
catch\s*\(                  # Catch blocks
throw new                   # Throw statements
\.catch\(                   # Promise catch
```

### React/Components

```regex
export.*React\.FC           # React functional components
export default function     # Default function exports
useState|useEffect          # React hooks
import.*from ['"]react['"]  # React imports
```

### Authentication

```regex
jwt|JWT                     # JWT usage
bearer|Bearer               # Bearer tokens
auth|Auth                   # Auth-related
session|Session             # Session handling
```

---

## Configuration Example

```json
{
  "my-skill": {
    "type": "domain",
    "enforcement": "suggest",
    "priority": "medium",
    "promptTriggers": {
      "keywords": ["keyword1", "keyword2"],
      "intentPatterns": [
        "(create|add).*?(feature|component)"
      ]
    },
    "fileTriggers": {
      "pathPatterns": [
        "src/services/**/*.ts"
      ],
      "pathExclusions": [
        "**/*.test.ts"
      ],
      "contentPatterns": [
        "import.*MyService"
      ]
    }
  }
}
```
