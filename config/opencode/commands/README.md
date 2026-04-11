# Commands Directory

Place custom slash command definitions (`.md` files) in this directory.

## Format

Commands are defined in markdown with YAML frontmatter:

```markdown
---
name: mycommand
description: What this command does
agent: build
model: openrouter/free
---

Template content for the command. Use $ARGUMENTS to reference user input.
```

## Examples

See [OpenCode Commands Documentation](https://opencode.ai/docs/commands) for full details.
