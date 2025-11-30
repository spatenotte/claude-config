# Conventional Commits Reference

## Message Structure

```
<type>[optional scope][optional !]: <description>

[optional body]

[optional footer(s)]
```

## Types

| Type | When to Use |
|------|-------------|
| **feat** | Introduces a new feature (correlates with MINOR in SemVer) |
| **fix** | Patches a bug (correlates with PATCH in SemVer) |
| **docs** | Documentation only changes |
| **style** | Changes that don't affect code meaning (whitespace, formatting, semicolons) |
| **refactor** | Code change that neither fixes a bug nor adds a feature |
| **perf** | Code change that improves performance |
| **test** | Adding missing tests or correcting existing tests |
| **build** | Changes to build system or external dependencies |
| **ci** | Changes to CI configuration files and scripts |
| **chore** | Other changes that don't modify src or test files |
| **revert** | Reverts a previous commit |

## Breaking Changes

Indicate breaking changes by:
1. Adding `!` after type/scope: `feat!: remove deprecated API`
2. Adding `BREAKING CHANGE:` footer in body

Breaking changes correlate with MAJOR in SemVer.

## Scope

Optional noun describing section of codebase:
- `feat(parser): add ability to parse arrays`
- `fix(api): handle null response`

## Examples

### Simple feature
```
feat: add user authentication
```

### Feature with scope
```
feat(auth): add OAuth2 support
```

### Bug fix with body
```
fix(api): handle null response from upstream

The external API occasionally returns null instead of an empty array.
Added null coalescing to prevent TypeError.
```

### Breaking change
```
refactor!: drop support for Node 14

BREAKING CHANGE: Minimum Node version is now 18.
```

### Multiple footers
```
fix(auth): resolve token refresh race condition

Implements mutex lock around token refresh to prevent
concurrent refresh attempts.

Reviewed-by: Jane
Refs: #123
```
