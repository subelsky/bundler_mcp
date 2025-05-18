# BundlerMCP

A Model Context Protocol (MCP) server enabling AI agents to query information about gems in a Ruby project's Gemfile, including source code and metadata. Built with [fast-mcp](https://github.com/yjacquin/fast-mcp).

[![CI](https://github.com/subelsky/bundler_mcp/actions/workflows/main.yml/badge.svg)](https://github.com/subelsky/bundler_mcp/actions/workflows/main.yml)

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add bundler_mcp --group=development
```

## Usage

First, generate the binstub:

```bash
bundle binstubs bundler_mcp
```

Then create an `mcp.json` configuration file. Here are some example configurations:

### Basic Configuration Example

```json
{
  "mcpServers": {
    "bundler-mcp": {
      "command": "/Users/mike/cool_app/bin/bundler_mcp"
    }
  }
}
```

### Configuration with Logging and Custom Gemfile

```json
{
  "mcpServers": {
    "bundler-mcp": {
      "command": "/Users/subelsky/code/bundler_mcp/bin/bundler_mcp",
      "env": {
        "BUNDLER_MCP_LOG_FILE": "/Users/subelsky/code/mcp.log"
      }
    }
  }
}
```

### Available Tools

The server provides two tools for AI agents:

#### list_project_gems

Lists all bundled Ruby gems with their:

- Versions
- Descriptions
- Installation paths
- Top-level documentation locations (e.g. `README` and `CHANGELOG`)

![list_project_gems tool](./docs/list_project_gems_screenshot.png)

#### get_gem_details

Retrieves detailed information about a specific gem, including:

- Version
- Description
- Installation path
- Top-level documentation locations
- Source code file locations

![get_gem_details tool](./docs/get_gem_details_screenshot.png)

## Environment Variables

- `BUNDLE_GEMFILE`: Used by Bundler to locate your Gemfile. If you use the binstub method described in the [Usage](#usage) section, this is usually not needed.
- `BUNDLER_MCP_LOG_FILE`: Path to log file. Useful for troubleshooting (defaults to no logging)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

### Testing with the MCP Inspector

You can test the server directly using the [MCP inspector](https://modelcontextprotocol.io/docs/tools/inspector):

```bash
# Basic usage
npx @modelcontextprotocol/inspector ./bin/bundler_mcp

# With logging enabled
BUNDLER_MCP_LOG_FILE=/tmp/log/mcp.log npx @modelcontextprotocol/inspector ./bin/bundler_mcp

# With custom Gemfile
BUNDLE_GEMFILE=./other/Gemfile npx @modelcontextprotocol/inspector ./bin/bundler_mcp
```

### Release Process

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version:

1. Update the version number in `version.rb`
2. Run `bundle exec rake release`

This will:

- Create a git tag for the version
- Push git commits and the created tag
- Push the `.gem` file to [rubygems.org](https://rubygems.org)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/subelsky/bundler_mcp.

## License

Open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Author

[Mike Subelsky](https://subelsky.com)
