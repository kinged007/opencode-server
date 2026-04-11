# MCP Servers Directory

Place MCP server configurations in this directory.

## Format

MCP servers can be configured in `opencode.jsonc` or as separate config files:

```json
{
  "mcpServers": {
    "my-server": {
      "command": "npx",
      "args": ["-y", "@myorg/mcp-server"]
    }
  }
}
```

## Examples

See [OpenCode MCP Documentation](https://opencode.ai/docs/mcp-servers) for full details.
