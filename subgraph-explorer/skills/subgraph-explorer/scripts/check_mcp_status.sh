#!/bin/bash
#
# Check the status of the Subgraph MCP Server
#
# This script checks if the subgraph-mcp Docker container is running
# and verifies that the endpoints are accessible.

set -e

echo "🔍 Checking Subgraph MCP Server status..."
echo ""

# Check if container is running
if docker ps | grep -q "subgraph-mcp-server"; then
    echo "✅ Container: Running"

    # Get container uptime
    UPTIME=$(docker ps --filter "name=subgraph-mcp-server" --format "{{.Status}}")
    echo "   Status: $UPTIME"

    # Check SSE endpoint
    echo ""
    echo "🌐 Checking endpoints..."
    if curl -s -f http://localhost:8000 > /dev/null 2>&1; then
        echo "   ✅ SSE endpoint (port 8000): Accessible"
    else
        echo "   ⚠️  SSE endpoint (port 8000): Not responding"
    fi

    # Check metrics endpoint
    if curl -s -f http://localhost:9091/metrics > /dev/null 2>&1; then
        echo "   ✅ Metrics endpoint (port 9091): Accessible"
    else
        echo "   ⚠️  Metrics endpoint (port 9091): Not responding"
    fi

    echo ""
    echo "📊 Recent logs:"
    docker logs --tail 10 subgraph-mcp-server

elif docker ps -a | grep -q "subgraph-mcp-server"; then
    echo "❌ Container: Stopped"
    echo ""
    echo "   Start with: scripts/start_mcp_server.sh"
    echo "   Or: docker-compose up -d (from subgraph-mcp directory)"
else
    echo "❌ Container: Not found"
    echo ""
    echo "   The subgraph-mcp-server container doesn't exist."
    echo "   Start it with: scripts/start_mcp_server.sh"
fi
