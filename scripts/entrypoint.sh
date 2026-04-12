#!/bin/bash
set -e

echo "Starting OpenCode Server..."
echo "Workspace directory: $WORKSPACE_DIR"
echo "Config directory: $OPENCODE_CONFIG_DIR"

# Ensure required directories exist
mkdir -p "$WORKSPACE_DIR"
mkdir -p "$OPENCODE_CONFIG_DIR"

if [ "$(id -u)" = "0" ]; then
	chown -R opencode:opencode "$WORKSPACE_DIR" "$OPENCODE_CONFIG_DIR" /home/opencode/.local/share/opencode || true
	chmod -R u+rwX,g+rwX "$WORKSPACE_DIR" "$OPENCODE_CONFIG_DIR" || true
	exec runuser -u opencode -- "$@"
fi

exec "$@"
