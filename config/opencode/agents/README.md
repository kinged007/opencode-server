# Agents Directory

Place custom agent definitions (`.md` files) in this directory.

## Format

Agents are defined in markdown with YAML frontmatter:

```markdown
---
description: Agent description
mode: subagent
tools:
  write: false
  edit: false
  bash: false
---

You are a specialized agent. Focus on specific tasks.
```

## Examples

See [OpenCode Agents Documentation](https://opencode.ai/docs/agents) for full details.
