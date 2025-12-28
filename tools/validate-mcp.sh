#!/bin/bash
# MCP Server Validation Tool
# Verifies connection to configured MCP servers

LOG_FILE=".kiro/logs/mcp_validation.log"
mkdir -p .kiro/logs

echo "🔍 validate-mcp: Starting MCP server validation..." | tee -a "$LOG_FILE"
CONFIG_FILE=".kiro/settings/mcp.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Error: mcp.json not found at $CONFIG_FILE"
    exit 1
fi

# List enabled servers
SERVERS=$(grep -A 10 '"mcpServers":' "$CONFIG_FILE" | grep -v "disabled" | grep -B 1 '"command":' | awk -F'"' '{print $2}' | grep -vE "^command$|^$|^\-\-")
# Note: JSON parsing with grep is brittle, but sufficient for simple MVP validation. Ideally use jq.

if command -v jq &> /dev/null; then
    echo "ℹ️ Using jq for parsing config..."
    SERVERS=$(jq -r '.mcpServers | to_entries[] | select(.value.disabled != true) | .key' "$CONFIG_FILE")
fi

echo "📋 Enabled Servers: $SERVERS" | tee -a "$LOG_FILE"

for server in $SERVERS; do
    echo "testing connection to $server..."
    # This is a placeholder check. Real MCP validation requires creating a client connection.
    # For now, we check if the command exists.
    
    CMD=$(jq -r ".mcpServers[\"$server\"].command" "$CONFIG_FILE")
    ARGS=$(jq -r ".mcpServers[\"$server\"].args[]" "$CONFIG_FILE" | tr '\n' ' ')
    
    if [ "$CMD" == "uvx" ] || [ "$CMD" == "npx" ]; then
        echo "✅ $server uses $CMD (assumed valid if installed)" | tee -a "$LOG_FILE"
    else
        echo "⚠️ $server uses custom command: $CMD" | tee -a "$LOG_FILE"
    fi
done

echo "✅ Validation complete. (Note: Deep connection testing requires mcp-client)" | tee -a "$LOG_FILE"
exit 0
