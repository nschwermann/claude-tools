# Subgraph Explorer Skill

A Claude Code skill for exploring and querying blockchain subgraphs through a private MCP server running in Docker.

## Description

This skill enables exploration and querying of blockchain subgraphs through a private MCP server. It provides tools for managing the Docker-based server, exploring GraphQL schemas, executing queries against configured subgraphs, and exporting discovered queries for project integration.

## Features

- **Docker Management**: Start, stop, and check status of the MCP server
- **Schema Exploration**: Introspect GraphQL schemas from subgraphs
- **Query Execution**: Execute GraphQL queries against configured or ad-hoc subgraph endpoints
- **Query Export**: Save discovered queries in multiple formats (JS, Python, GraphQL, JSON)
- **Comprehensive Patterns**: Reference guide with common GraphQL query patterns for blockchain data

## Use Cases

- Exploring NFT transfers and ownership data
- Querying DEX swaps and trading volume
- Analyzing DeFi protocol metrics
- Examining subgraph schemas and entities
- Exporting queries for project integration

## Requirements

- Docker and Docker Compose
- Private Subgraph MCP Server (https://github.com/nschwermann/subgraph-mcp)
- Python 3 (for query export utility)

## Installation

### As a Claude Code Skill

1. Download the `subgraph-explorer.zip` file
2. Install via Claude Code plugin system, or
3. Extract to your Claude skills directory

### From Source

```bash
# Clone or download this repository
git clone <repository-url>

# The skill is ready to use
# Scripts are in scripts/
# Reference docs are in references/
# Main instructions are in SKILL.md
```

## Quick Start

### Starting the MCP Server

```bash
bash scripts/start_mcp_server.sh
```

This starts the Docker container with:
- **SSE endpoint**: `http://localhost:8000` (for MCP communication)
- **Metrics endpoint**: `http://localhost:9091/metrics` (for monitoring)

### Check Server Status

```bash
bash scripts/check_mcp_status.sh
```

### Stop the Server

```bash
bash scripts/stop_mcp_server.sh
```

## Exporting Queries

Export discovered GraphQL queries for project use:

### JavaScript/TypeScript
```bash
python3 scripts/export_query.py queries/myQuery.js --format js --name MyQuery
```

### Python
```bash
python3 scripts/export_query.py queries/myQuery.py --format py --name my_query
```

### GraphQL
```bash
python3 scripts/export_query.py queries/myQuery.graphql --format graphql
```

### JSON
```bash
python3 scripts/export_query.py queries/myQuery.json --format json --name MyQuery
```

## Structure

```
subgraph-explorer/
├── SKILL.md                           # Main skill documentation
├── scripts/
│   ├── start_mcp_server.sh           # Start Docker MCP server
│   ├── stop_mcp_server.sh            # Stop Docker MCP server
│   ├── check_mcp_status.sh           # Check server status
│   └── export_query.py               # Export queries to various formats
└── references/
    └── graphql_patterns.md           # GraphQL query patterns reference
```

## Configuration

The scripts default to `~/Workspace/subgraph-mcp` as the MCP server project path. Override by setting the `SUBGRAPH_MCP_PATH` environment variable:

```bash
export SUBGRAPH_MCP_PATH=/path/to/your/subgraph-mcp
bash scripts/start_mcp_server.sh
```

## MCP Server Tools

The skill works with the following MCP server tools:

**Registry-based:**
- `list_subgraphs` - List all configured subgraphs
- `search_subgraphs_by_keyword` - Search subgraphs by keyword
- `get_schema_by_id` - Get GraphQL schema for a subgraph
- `execute_query_by_id` - Execute query against a subgraph
- `get_query_examples_by_id` - Get query examples
- `get_subgraph_guidance_by_id` - Get subgraph-specific guidance

**Ad-hoc:**
- `get_schema_by_url` - Get schema from any GraphQL endpoint
- `execute_query_by_url` - Execute query against any GraphQL endpoint

## Documentation

See `SKILL.md` for comprehensive documentation including:
- Core workflows for subgraph exploration
- Query development process
- Data considerations and best practices
- Troubleshooting guide
- Tips and tricks

See `references/graphql_patterns.md` for:
- Pagination strategies
- Filtering and aggregation patterns
- Performance optimization techniques
- Common query scenarios

## License

MIT

## Related Projects

- [Private Subgraph MCP Server](https://github.com/nschwermann/subgraph-mcp) - The MCP server this skill interacts with
- [Claude Code](https://claude.com/claude-code) - The AI coding assistant platform
