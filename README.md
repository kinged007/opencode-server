# OpenCode Server

Docker deployment for [OpenCode](https://opencode.ai) Server on VPS.

## Quick Start

1. Copy `.env.example` to `.env` and configure your API keys
2. Run `docker-compose up -d`
3. Access OpenCode at `http://your-vps-ip:4096`

## Configuration

Edit `config/opencode/opencode.jsonc` to customize:
- LLM providers and models
- Agent configurations
- Permissions and tools

## Workspaces

Projects are stored in the `workspaces/` directory, mounted as a volume.

## Environment Variables

| Variable | Description |
|----------|-------------|
| `OPENROUTER_API_KEY` | OpenRouter provider API key |
| `OPENAI_API_KEY` | OpenAI provider API key |
| `ANTHROPIC_API_KEY` | Anthropic provider API key |
| `OPENCODE_SERVER_PASSWORD` | Server authentication password |
| `OPENCODE_SERVER_USERNAME` | Server auth username (default: opencode) |

## Package Managers Included

- **Node.js** (v22) with npm
- **pnpm** - Fast, disk space efficient package manager
- **bun** - All-in-one JavaScript runtime & package manager
- **uv** - Fast Python package manager (written in Rust)
- **Rust** - Systems programming language

## Adding Customizations

Place customizations in the `config/opencode/` directory:

- `agents/` - Custom agent definitions
- `commands/` - Custom slash commands
- `skills/` - Agent skills
- `tools/` - Custom tools
- `mcp/` - MCP server configurations
- `plugins/` - OpenCode plugins
- `themes/` - UI themes

## Building

```bash
# Development
docker-compose up --build

# Production
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up --build -d
```

## License

MIT
