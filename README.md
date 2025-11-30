# claude-config

Personal Claude Code configuration with skills, custom statusline, and plugins.

## Installation

### As a Plugin (Recommended)

```bash
# Add the marketplace
/plugin marketplace add spatenotte/claude-config

# Install the plugin
/plugin install claude-config@spatenotte-marketplace

# Update to latest
/plugin update claude-config
```

### Alternative: Symlink

```bash
# Clone somewhere central
git clone git@github.com:spatenotte/claude-config.git ~/.claude-config

# Symlink in each project
ln -s ~/.claude-config .claude
```

### Alternative: Submodule

```bash
git submodule add git@github.com:spatenotte/claude-config.git .claude
```

## Contents

### Skills

| Skill | Description |
|-------|-------------|
| `conventional-commit` | Create git commits following Conventional Commits spec |
| `skill-developer` | Guide for creating and managing Claude Code skills |

### Included Plugins

- [superpowers](https://github.com/obra/superpowers) - Auto-enabled

### Custom Statusline

Displays model, git branch, directory, cost, and duration. Requires `jq`.

## Creating Skills

See the `skill-developer` skill or the [Anthropic skill-creator](https://github.com/anthropics/skills/tree/main/skill-creator).
