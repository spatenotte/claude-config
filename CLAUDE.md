# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repository is a reusable `.claude` directory intended to be added as a git submodule at the root of other projects. It contains shared skills, commands, hooks, and agents.

## Usage as Submodule

```bash
# Add to a project
git submodule add <repo-url> .claude

# Update in a project
git submodule update --remote .claude
```

## Directory Structure

```
.claude/                    # This repo becomes .claude/ in target projects
├── skills/                 # Claude Code skills
│   └── {skill-name}/
│       ├── SKILL.md        # Required: frontmatter + instructions
│       ├── scripts/        # Optional: executable code
│       ├── references/     # Optional: detailed documentation
│       └── assets/         # Optional: templates, boilerplate
├── commands/               # Slash commands (*.md files)
├── hooks/                  # Hook scripts
├── agents/                 # Agent definitions
└── settings.json           # Claude Code settings (hooks, permissions)
```

## Creating New Skills

Use the skill-creator pattern from https://github.com/anthropics/skills/tree/main/skill-creator

Or use the `skills/skill-developer` skill for hook-based auto-activation.

### Key Principles

1. **Conciseness** - Context window is shared; only include what Claude genuinely needs
2. **Progressive Disclosure** - SKILL.md body <500 lines; use references/ for details
3. **Skill name** - Hyphen-case, max 40 characters, matches directory name
