# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **Claude Code plugin marketplace** that provides specialized plugins for blockchain development, subgraph exploration, and workflow automation. The repository serves as both a marketplace for distributing plugins and a development workspace for creating new plugins.

## Architecture

### Marketplace Structure

The repository follows the Claude Code plugin marketplace pattern:

```
claude-tools/
├── .claude-plugin/
│   └── marketplace.json          # Marketplace metadata and plugin registry
├── {plugin-name}/                # Individual plugin directories
│   ├── .claude-plugin/
│   │   └── plugin.json          # Plugin metadata, requirements, keywords
│   ├── skills/                  # Agent Skills (optional)
│   ├── commands/                # Custom slash commands (optional)
│   ├── agents/                  # Custom agents (optional)
│   └── hooks/                   # Event handlers (optional)
└── README.md
```

### Plugin Types

Each plugin can contain multiple component types:
- **Skills**: Agent Skills that expand Claude's capabilities with specialized knowledge
- **Commands**: Custom slash commands for specific workflows
- **Agents**: Specialized agent types for complex tasks
- **Hooks**: Event handlers for responding to tool calls and user actions

## Key Files

### Marketplace Configuration
- `.claude-plugin/marketplace.json` - Defines marketplace metadata and the plugin registry (name, description, owner, list of plugins)

### Plugin Configuration
- `{plugin}/.claude-plugin/plugin.json` - Plugin metadata including:
  - Name, description, version, author
  - Keywords for discoverability
  - External requirements (Docker, Python, etc.)
  - Repository information

### Skill Structure
- `{plugin}/skills/{skill-name}/SKILL.md` - Main skill instructions and prompts that Claude receives when the skill is invoked
- `{plugin}/skills/{skill-name}/scripts/` - Utility scripts that skills can execute
- `{plugin}/skills/{skill-name}/references/` - Reference documentation and guides included in skill context

## Current Plugins

### subgraph-explorer

A plugin for exploring and querying blockchain subgraphs through a private MCP server.

**Key Components:**
- **Skill**: `subgraph-explorer` - Main skill for GraphQL subgraph exploration
- **Scripts**: Docker management (`start_mcp_server.sh`, `stop_mcp_server.sh`, `check_mcp_status.sh`) and query export (`export_query.py`)
- **References**: `graphql_patterns.md` - Comprehensive GraphQL patterns guide

**External Dependencies:**
- Docker and Docker Compose (for MCP server)
- Python 3 (for export utility)
- Private Subgraph MCP Server at `~/Workspace/subgraph-mcp` (configurable via `SUBGRAPH_MCP_PATH`)

**MCP Server Integration:**
- SSE endpoint: `http://localhost:8000`
- Metrics endpoint: `http://localhost:9091/metrics`
- Container name: `subgraph-mcp-server`

## Development Workflows

### Testing Plugins Locally

When developing or modifying plugins:

```shell
# Add marketplace locally
/plugin marketplace add ./

# Install plugin
/plugin install {plugin-name}@claude-tools

# After making changes, reinstall
/plugin uninstall {plugin-name}@claude-tools
/plugin install {plugin-name}@claude-tools
```

### Adding New Plugins

1. Create plugin directory: `mkdir {plugin-name}`
2. Create `.claude-plugin/plugin.json` with metadata
3. Add plugin components (skills, commands, agents, hooks)
4. Register in `.claude-plugin/marketplace.json`
5. Test locally before committing

### Skill Development

Skills are defined in `SKILL.md` files with:
- Front matter (name, description) using YAML between `---` markers
- Detailed instructions and workflows for Claude
- References to supporting scripts and documentation

**Important**: The `description` in the front matter determines when Claude automatically invokes the skill.

### Script Conventions

**Shell Scripts:**
- Use `#!/bin/bash` shebang
- Set `set -e` for error handling
- Support environment variable overrides (e.g., `SUBGRAPH_MCP_PATH`)
- Provide clear error messages with ❌/✅ indicators
- Default to `$HOME/Workspace/{project}` for external dependencies

**Python Scripts:**
- Use `#!/usr/bin/env python3` shebang
- Include module docstring with usage examples
- Support `--help` via argparse
- Create parent directories as needed (`mkdir -p` equivalent)
- Provide clear success/error feedback

## Plugin Installation Flow

Users install plugins via:
```shell
/plugin marketplace add nschwermann/claude-tools
/plugin install {plugin-name}@claude-tools
```

This makes all plugin components (skills, commands, etc.) available to Claude Code immediately.

## Git Workflow

The repository uses a simple Git workflow:
- Main branch: `master`
- Single commit structure currently (initial marketplace setup)
- Clean working directory expected between changes
