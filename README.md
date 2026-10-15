# OpenCode Server

[![CI](https://github.com/kinged007/opencode-server/actions/workflows/ci.yml/badge.svg)](https://github.com/kinged007/opencode-server/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Self-hosted Docker deployment for [OpenCode](https://opencode.ai) Server on VPS — multi-provider LLM support, MCP integrations, and ready-to-run agent workspaces.

## What it is

OpenCode Server packages the OpenCode AI coding-agent as a VPS-ready Docker stack. It comes with a full toolchain (Node.js, pnpm, bun, uv, Rust), configurable LLM providers (OpenRouter, OpenAI, Anthropic), and MCP server support (Context7, context-mode). Drop your projects into `workspaces/` and you have a persistent, self-hosted agent environment.

## Install

```bash
cp .env.example .env   # fill in your API keys
docker compose up -d --build
```

Open `http://your-vps-ip:4096` — OpenCode is running.

## Usage

### Configuration

Edit `config/opencode/opencode.jsonc`:

- `provider` — LLM providers and models
- `agent` — agent configurations (`build` / `plan`)
- `permission` — per-tool allow/ask/deny rules
- `mcp` — MCP server configurations

### Workspaces

Place projects in `workspaces/` — mounted as a persistent volume inside the container.

```
workspaces/
├── project-1/
└── project-2/
```

### Environment Variables

| Variable | Description |
|----------|-------------|
| `OPENROUTER_API_KEY` | OpenRouter API key |
| `OPENAI_API_KEY` | OpenAI API key |
| `ANTHROPIC_API_KEY` | Anthropic API key |
| `CONTEXT7_API_KEY` | Context7 MCP API key |
| `OPENCODE_SERVER_PASSWORD` | Server auth password |
| `OPENCODE_SERVER_USERNAME` | Server auth username (default `opencode`) |

### Package managers included

- Node.js v22 + npm, pnpm, bun
- uv (Python)
- Rust (rustup + cargo)
- git, GitHub CLI (`gh`)

### Building

```bash
# Development
docker compose up --build

# Production overlay
docker compose -f docker-compose.yml -f docker-compose.prod.yml up --build -d
```

### Customizations

`config/opencode/` holds agent definitions, slash commands, skills, tools, MCP configs, plugins, and themes — all mounted into the container.

## How it is tested

CI (`.github/workflows/ci.yml`) runs on push and pull requests to `main`:

- Docker build verification (`docker build` + `docker compose config`)
- Shell lint (`shellcheck` on `scripts/entrypoint.sh`)
- JSONC config validation (`config/opencode/opencode.jsonc`)

Run these locally before opening a PR.

## License

MIT — see [LICENSE](LICENSE).
