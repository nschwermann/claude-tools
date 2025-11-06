# Claude Tools

A collection of custom Claude Code plugins for blockchain development, subgraph exploration, and workflow automation.

## What is this?

This repository is a **Claude Code plugin marketplace** that provides specialized tools and Skills for working with blockchain data, GraphQL subgraphs, and development workflows. All plugins can be installed directly into Claude Code for enhanced capabilities.

## Available Plugins

### 🔍 Subgraph Explorer

Explore and query blockchain subgraphs through a private MCP server running in Docker.

**Features:**
- Docker management scripts for MCP server (start, stop, status)
- GraphQL schema exploration and introspection
- Query execution against configured or ad-hoc subgraph endpoints
- Query export utility (JavaScript, Python, GraphQL, JSON formats)
- Comprehensive GraphQL patterns reference for blockchain data

**Use Cases:**
- Querying NFT transfers and ownership data
- Analyzing DEX swaps and trading volume
- Exploring DeFi protocol metrics
- Exporting queries for project integration

**Requirements:** Docker, Docker Compose, Python 3

[View Plugin Details →](./subgraph-explorer/)

## Installation

### Quick Start

1. **Add this marketplace to Claude Code:**
   ```shell
   /plugin marketplace add nschwermann/claude-tools
   ```

2. **Install a plugin:**
   ```shell
   /plugin install subgraph-explorer@claude-tools
   ```

3. **Use the plugin:**
   - Skills are automatically available to Claude
   - Check `/help` for new commands (if any)
   - Follow plugin-specific documentation for setup

### Alternative: Local Development

For local testing or development:

```bash
# Clone the repository
git clone https://github.com/nschwermann/claude-tools.git

# Add as local marketplace
/plugin marketplace add ./claude-tools

# Install plugins
/plugin install subgraph-explorer@claude-tools
```

## Plugin Structure

This marketplace follows the Claude Code plugin structure:

```
claude-tools/
├── .claude-plugin/
│   └── marketplace.json          # Marketplace metadata
├── subgraph-explorer/            # Plugin: Subgraph Explorer
│   ├── .claude-plugin/
│   │   └── plugin.json          # Plugin metadata
│   └── skills/
│       └── subgraph-explorer/   # Skill implementation
│           ├── SKILL.md
│           ├── scripts/
│           ├── references/
│           └── README.md
└── README.md                     # This file
```

## Development

### Adding New Plugins

To add a new plugin to this marketplace:

1. **Create plugin directory:**
   ```bash
   mkdir my-plugin
   cd my-plugin
   ```

2. **Create plugin manifest:**
   ```bash
   mkdir .claude-plugin
   # Create .claude-plugin/plugin.json with plugin metadata
   ```

3. **Add plugin components:**
   - `skills/` - Agent Skills
   - `commands/` - Custom slash commands
   - `agents/` - Custom agents
   - `hooks/` - Event handlers

4. **Update marketplace manifest:**
   Add your plugin to `.claude-plugin/marketplace.json`

5. **Test locally:**
   ```shell
   /plugin marketplace add ./claude-tools
   /plugin install my-plugin@claude-tools
   ```

### Testing Changes

When developing plugins locally:

```shell
# Uninstall current version
/plugin uninstall plugin-name@claude-tools

# Reinstall after changes
/plugin install plugin-name@claude-tools
```

## Requirements

- **Claude Code** - Latest version recommended
- **Git** - For cloning and version control
- **Plugin-specific requirements** - See individual plugin documentation

## Related Projects

- [Private Subgraph MCP Server](https://github.com/nschwermann/subgraph-mcp) - The MCP server used by subgraph-explorer
- [Claude Code Documentation](https://docs.claude.com/claude-code) - Official Claude Code docs

## Contributing

Contributions are welcome! To contribute:

1. Fork this repository
2. Create a feature branch
3. Add or improve a plugin
4. Submit a pull request

## License

MIT

## Author

**Nathan Schwermann**
- GitHub: [@nschwermann](https://github.com/nschwermann)

---

Built for use with [Claude Code](https://claude.com/claude-code) - The AI coding assistant
