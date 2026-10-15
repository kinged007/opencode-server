# AGENTS.md — opencode-server

## Purpose

Self-hosted Docker stack for the [OpenCode](https://opencode.ai) AI coding-agent server. Runs on a VPS via Docker Compose, mounts `workspaces/` as the agent working directory, and exposes OpenCode on port 4096 with configurable LLM providers and MCP servers.

## How to work in this repo

- **No direct pushes to `main`.** Work on a branch and open a PR (e.g. `chore/polish-profile`).
- Keep PRs small and include a clear description of the change and how it was tested.
- Use verified identity: `kinged007 <599286+kinged007@users.noreply.github.com>`.
- No secrets in commits — `.env` is gitignored; only `.env.example` belongs in the repo.

## Running checks

```bash
# Validate compose and build
docker compose config -q
docker build -t opencode-server:ci .

# Lint shell
shellcheck scripts/entrypoint.sh

# Validate config JSONC
node -e "
const fs=require('fs');
const raw=fs.readFileSync('config/opencode/opencode.jsonc','utf8');
const stripped=raw.replace(/^\s*\/\/.*$/gm,'').replace(/\/\*[\s\S]*?\*\//g,'');
JSON.parse(stripped); console.log('opencode.jsonc: valid JSONC');
"
```

CI (`.github/workflows/ci.yml`) runs the same checks on push/PR to `main`.

## Skills

- Use `context-mode` and Context7 MCP servers (configured in `config/opencode/opencode.jsonc`) where they help.
- Prefer existing conventions in `config/opencode/` and `scripts/` before adding new structure.

## Notes

- Do not publish anything derived from private `tenantflex` org repos (see workspace docs/03-tenantflex.md) without written approval from the org owner.
- Building the full image is heavy — for doc-only changes `docker compose config -q` is enough to gate the PR.
