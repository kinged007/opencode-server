#!/bin/bash
set -e

echo "Starting OpenCode Server..."
echo "Workspace directory: $WORKSPACE_DIR"
echo "Config directory: $OPENCODE_CONFIG_DIR"

# Ensure workspace directory exists and is writable
mkdir -p "$WORKSPACE_DIR"
chown -R opencode:opencode "$(dirname "$WORKSPACE_DIR")"

# Ensure config directory exists
mkdir -p "$OPENCODE_CONFIG_DIR"
chown -R opencode:opencode "$OPENCODE_CONFIG_DIR"

# Execute the main command
exec "$@"
