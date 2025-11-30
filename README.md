# .claude

Reusable Claude Code configuration intended to be added as a git submodule at `.claude` in other projects.

## Usage

```bash
# Add to a project
git submodule add <repo-url> .claude

# Clone a project with this submodule
git clone --recurse-submodules <project-url>

# Update submodule to latest
git submodule update --remote .claude
```

## Contents

### Skills

| Skill | Description |
|-------|-------------|
| `conventional-commit` | Create git commits following Conventional Commits spec |
| `skill-developer` | Guide for creating and managing Claude Code skills |

### Structure

```
.claude/
├── skills/           # Claude Code skills
├── commands/         # Slash commands
├── hooks/            # Hook scripts
├── agents/           # Agent definitions
└── settings.json     # Claude Code settings
```

## Creating Skills

See the `skill-developer` skill or the [Anthropic skill-creator](https://github.com/anthropics/skills/tree/main/skill-creator).
