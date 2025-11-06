#!/usr/bin/env python3
"""
Export GraphQL Query Utility

This script helps export discovered GraphQL queries into reusable formats
for easy integration into projects. It supports multiple output formats:
- JavaScript/TypeScript module
- Python module
- Plain GraphQL file
- JSON format with metadata

Usage:
    python3 export_query.py <output_file> [--format js|py|graphql|json] [--name QueryName]

    Then paste your GraphQL query when prompted, and press Ctrl+D (Unix) or Ctrl+Z (Windows) when done.

Examples:
    # Export as JavaScript
    python3 export_query.py queries/myQuery.js --format js --name GetLatestSwaps

    # Export as Python
    python3 export_query.py queries/myQuery.py --format py --name get_latest_swaps

    # Export as plain GraphQL
    python3 export_query.py queries/myQuery.graphql --format graphql
"""

import sys
import argparse
import json
from pathlib import Path
from datetime import datetime


def format_js(query: str, name: str, description: str = "") -> str:
    """Format query as JavaScript/TypeScript module."""
    comment = f"/**\n * {description}\n */\n" if description else ""
    return f"""{comment}export const {name} = `
{query}
`;
"""


def format_python(query: str, name: str, description: str = "") -> str:
    """Format query as Python module."""
    docstring = f'    """{description}"""\n' if description else ""
    return f'''{name} = """
{query}
"""
{docstring}
'''


def format_graphql(query: str, description: str = "") -> str:
    """Format as plain GraphQL with optional comment."""
    comment = f"# {description}\n\n" if description else ""
    return f"{comment}{query}\n"


def format_json(query: str, name: str, description: str = "", variables: dict = None) -> str:
    """Format as JSON with metadata."""
    data = {
        "name": name,
        "description": description,
        "query": query,
        "variables": variables or {},
        "exported_at": datetime.now().isoformat()
    }
    return json.dumps(data, indent=2)


def read_multiline_input(prompt: str) -> str:
    """Read multiline input from stdin."""
    print(prompt)
    print("(Press Ctrl+D on Unix/Mac or Ctrl+Z on Windows when done)")
    print("-" * 60)
    lines = []
    try:
        while True:
            line = input()
            lines.append(line)
    except EOFError:
        pass
    print("-" * 60)
    return "\n".join(lines).strip()


def main():
    parser = argparse.ArgumentParser(
        description="Export GraphQL queries into various formats for project use",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__
    )
    parser.add_argument("output", help="Output file path")
    parser.add_argument(
        "--format",
        choices=["js", "py", "graphql", "json"],
        help="Output format (default: inferred from file extension)"
    )
    parser.add_argument("--name", help="Query name (required for js/py/json formats)")
    parser.add_argument("--description", default="", help="Query description")
    parser.add_argument("--variables", help="JSON string of query variables (for json format)")

    args = parser.parse_args()

    # Infer format from extension if not provided
    output_path = Path(args.output)
    format_type = args.format
    if not format_type:
        ext = output_path.suffix.lower()
        format_map = {".js": "js", ".ts": "js", ".py": "py", ".graphql": "graphql", ".gql": "graphql", ".json": "json"}
        format_type = format_map.get(ext)
        if not format_type:
            print(f"❌ Error: Cannot infer format from extension '{ext}'. Please specify --format", file=sys.stderr)
            sys.exit(1)

    # Validate name requirement
    if format_type in ["js", "py", "json"] and not args.name:
        print(f"❌ Error: --name is required for {format_type} format", file=sys.stderr)
        sys.exit(1)

    # Read the GraphQL query
    query = read_multiline_input("\n📝 Paste your GraphQL query:")
    if not query:
        print("❌ Error: No query provided", file=sys.stderr)
        sys.exit(1)

    # Parse variables if provided
    variables = None
    if args.variables:
        try:
            variables = json.loads(args.variables)
        except json.JSONDecodeError as e:
            print(f"❌ Error: Invalid JSON in --variables: {e}", file=sys.stderr)
            sys.exit(1)

    # Format the output
    formatters = {
        "js": lambda: format_js(query, args.name, args.description),
        "py": lambda: format_python(query, args.name, args.description),
        "graphql": lambda: format_graphql(query, args.description),
        "json": lambda: format_json(query, args.name, args.description, variables)
    }

    output = formatters[format_type]()

    # Create parent directory if it doesn't exist
    output_path.parent.mkdir(parents=True, exist_ok=True)

    # Write the output
    output_path.write_text(output)

    print(f"\n✅ Query exported successfully to: {output_path}")
    print(f"   Format: {format_type}")
    if args.name:
        print(f"   Name: {args.name}")


if __name__ == "__main__":
    main()
