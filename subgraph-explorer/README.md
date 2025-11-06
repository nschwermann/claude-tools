# Subgraph Explorer Plugin

A Claude Code plugin that enables exploration and querying of blockchain subgraphs through a private MCP server running in Docker.

## Overview

This plugin adds a powerful Skill to Claude Code for working with blockchain subgraphs. It provides Docker management utilities, GraphQL schema exploration, query execution, and export tools for integrating queries into your projects.

## Features

### Skill: Subgraph Explorer

The main Skill enables Claude to:

- **Manage MCP Server**: Start, stop, and check status of Docker-based MCP server
- **Explore Schemas**: Introspect GraphQL schemas from configured or ad-hoc subgraph endpoints
- **Execute Queries**: Run GraphQL queries against subgraphs (NFT, DEX, DeFi data)
- **Export Queries**: Save discovered queries in multiple formats (JS, Python, GraphQL, JSON)
- **Access Patterns**: Reference guide with common GraphQL patterns for blockchain data

### Included Utilities

#### Docker Management Scripts
- `start_mcp_server.sh` - Start the MCP server container
- `stop_mcp_server.sh` - Stop the MCP server container
- `check_mcp_status.sh` - Check server status and health

#### Query Export Tool
- `export_query.py` - Export queries to JavaScript, Python, GraphQL, or JSON

#### Reference Documentation
- `graphql_patterns.md` - Comprehensive GraphQL query patterns for blockchain subgraphs

## Installation

### From Marketplace

```shell
/plugin marketplace add nschwermann/claude-tools
/plugin install subgraph-explorer@claude-tools
```

### Local Development

```bash
git clone https://github.com/nschwermann/claude-tools.git
cd claude-tools
```

```shell
/plugin marketplace add ./
/plugin install subgraph-explorer@claude-tools
```

## Requirements

- **Docker and Docker Compose** - For running the MCP server
- **Python 3** - For query export utility
- **Private Subgraph MCP Server** - [nschwermann/subgraph-mcp](https://github.com/nschwermann/subgraph-mcp)

## Quick Start

After installing the plugin, the Skill is automatically available to Claude.

### 1. Start the MCP Server

The skill can help you start the Docker-based MCP server:

```
You: Start the subgraph MCP server

Claude will execute the start script and verify the server is running.
```

### 2. Explore Subgraphs

Ask Claude to explore subgraphs:

```
You: Show me the latest NFT transfers from the Ebisu's Bay subgraph

Claude will:
1. List or search for the relevant subgraph
2. Get the GraphQL schema
3. Build and execute an appropriate query
4. Present the results
```

### 3. Export Queries

Save working queries for your projects:

```
You: Export that query as a JavaScript module

Claude will use the export utility to save the query in your preferred format.
```

## Usage Examples

### Exploring NFT Data
```
You: What NFTs does address 0x123... own on Cronos?
```

Claude will search the NFT subgraph, build a query for ERC721/ERC1155 balances, and show the results.

### Analyzing DEX Volume
```
You: Show me today's trading volume on Ebisu's Bay DEX
```

Claude will query the DEX subgraph for daily volume data, handling UTC timezone considerations.

### Ad-hoc Exploration
```
You: Explore the GraphQL schema at https://example.com/graphql
```

Claude will introspect the schema and help you build queries even for unconfigured endpoints.

## Configuration

The scripts default to `~/Workspace/subgraph-mcp` for the MCP server location. Override with:

```bash
export SUBGRAPH_MCP_PATH=/path/to/your/subgraph-mcp
```

The MCP server configuration (`subgraphs.json`) defines which subgraphs are available in the registry.

## Skill Structure

```
subgraph-explorer/
├── .claude-plugin/
│   └── plugin.json              # Plugin metadata
└── skills/
    └── subgraph-explorer/       # Skill implementation
        ├── SKILL.md            # Main skill instructions
        ├── scripts/
        │   ├── start_mcp_server.sh
        │   ├── stop_mcp_server.sh
        │   ├── check_mcp_status.sh
        │   └── export_query.py
        └── references/
            └── graphql_patterns.md
```

## MCP Server Integration

This plugin works with the Private Subgraph MCP Server, which provides:

**Registry-based tools:**
- `list_subgraphs` - List configured subgraphs
- `search_subgraphs_by_keyword` - Search by keyword
- `get_schema_by_id` - Get schema for configured subgraph
- `execute_query_by_id` - Execute query against configured subgraph
- `get_query_examples_by_id` - Get query examples
- `get_subgraph_guidance_by_id` - Get usage guidance

**Ad-hoc tools:**
- `get_schema_by_url` - Get schema from any GraphQL endpoint
- `execute_query_by_url` - Execute query against any endpoint

## Documentation

See the skill's `SKILL.md` for comprehensive documentation including:
- Core workflows for subgraph exploration
- Query development process
- Data considerations and best practices
- Troubleshooting guide

## Related Projects

- [claude-tools](https://github.com/nschwermann/claude-tools) - This plugin marketplace
- [subgraph-mcp](https://github.com/nschwermann/subgraph-mcp) - The MCP server
- [Claude Code](https://claude.com/claude-code) - The AI coding assistant

## License

MIT

## Author

**Nathan Schwermann**
- GitHub: [@nschwermann](https://github.com/nschwermann)
