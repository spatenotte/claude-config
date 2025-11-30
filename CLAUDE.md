# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repository stores reusable Claude Code skills for sharing across personal projects.

## Creating New Skills

When creating or updating skills, use the skill-creator pattern from https://github.com/anthropics/skills/tree/main/skill-creator

### Skill Structure

Each skill is a directory containing:
- `SKILL.md` (required) - YAML frontmatter (name, description) + Markdown instructions
- `scripts/` - Executable code for deterministic/repeated tasks
- `references/` - Documentation loaded as needed (schemas, APIs, workflows)
- `assets/` - Output resources (templates, boilerplate) not loaded into context

### Key Design Principles

1. **Conciseness** - Context window is shared; only include what Claude genuinely needs
2. **Degrees of Freedom** - Match specificity to task: high freedom for flexible approaches, low for fragile/sequential operations
3. **Progressive Disclosure** - Metadata (~100 words) always visible; SKILL.md body (<5k words) loaded on trigger; bundled resources loaded as needed

### SKILL.md Guidelines

- Use imperative/infinitive form
- Put "when to use" details in frontmatter description, not body
- Write for another Claude instance to understand
- Keep under 500 lines; split longer content into references
- Skill name must be hyphen-case, max 40 characters
