#!/bin/bash
#
# Start the Subgraph MCP Server using Docker Compose
#
# This script starts the subgraph-mcp server in Docker, which exposes:
# - Port 8000: SSE endpoint for MCP communication
# - Port 9091: Prometheus metrics endpoint
#
# The server runs in SSE mode and uses the subgraphs.json configuration
# from the subgraph-mcp project directory.

set -e

# Default path to subgraph-mcp project
SUBGRAPH_MCP_PATH="${SUBGRAPH_MCP_PATH:-$HOME/Workspace/subgraph-mcp}"

echo "🚀 Starting Subgraph MCP Server..."
echo "   Project path: $SUBGRAPH_MCP_PATH"

# Check if the directory exists
if [ ! -d "$SUBGRAPH_MCP_PATH" ]; then
    echo "❌ Error: Directory not found: $SUBGRAPH_MCP_PATH"
    echo "   Set SUBGRAPH_MCP_PATH environment variable to the correct path"
    exit 1
fi

# Check if docker-compose.yml exists
if [ ! -f "$SUBGRAPH_MCP_PATH/docker-compose.yml" ]; then
    echo "❌ Error: docker-compose.yml not found in $SUBGRAPH_MCP_PATH"
    exit 1
fi

# Check if subgraphs.json exists
if [ ! -f "$SUBGRAPH_MCP_PATH/subgraphs.json" ]; then
    echo "⚠️  Warning: subgraphs.json not found in $SUBGRAPH_MCP_PATH"
    echo "   The server may not work properly without configuration"
fi

# Change to the project directory
cd "$SUBGRAPH_MCP_PATH"

# Start the server using docker-compose
echo "   Starting Docker container..."
docker-compose up -d

# Wait for the server to be ready
echo "   Waiting for server to be ready..."
sleep 3

# Check if the container is running
if docker ps | grep -q "subgraph-mcp-server"; then
    echo "✅ Subgraph MCP Server started successfully"
    echo "   SSE endpoint: http://localhost:8000"
    echo "   Metrics endpoint: http://localhost:9091/metrics"
    echo ""
    echo "   View logs: docker logs -f subgraph-mcp-server"
    echo "   Stop server: docker-compose down (from $SUBGRAPH_MCP_PATH)"
else
    echo "❌ Failed to start server. Check logs with:"
    echo "   docker logs subgraph-mcp-server"
    exit 1
fi
