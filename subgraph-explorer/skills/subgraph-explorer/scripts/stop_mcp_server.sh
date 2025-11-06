#!/bin/bash
#
# Stop the Subgraph MCP Server
#
# This script stops the subgraph-mcp Docker container and cleans up resources.

set -e

# Default path to subgraph-mcp project
SUBGRAPH_MCP_PATH="${SUBGRAPH_MCP_PATH:-$HOME/Workspace/subgraph-mcp}"

echo "🛑 Stopping Subgraph MCP Server..."
echo "   Project path: $SUBGRAPH_MCP_PATH"

# Check if the directory exists
if [ ! -d "$SUBGRAPH_MCP_PATH" ]; then
    echo "❌ Error: Directory not found: $SUBGRAPH_MCP_PATH"
    echo "   Set SUBGRAPH_MCP_PATH environment variable to the correct path"
    exit 1
fi

# Change to the project directory
cd "$SUBGRAPH_MCP_PATH"

# Stop the server
docker-compose down

echo "✅ Subgraph MCP Server stopped"
