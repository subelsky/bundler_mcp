# BundlerMCP

TODO: Delete this and the text below, and describe your gem
## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add bundler_mcp
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install bundler_mcp
```

## Usage

`bundle binstubs bundler_mcp` - then setup mcp.json to invoke `bin/bundler_mcp`

Todo: mention using `BUNDLE_GEMFILE=`  to override the default Gemfile

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

You can run the server directly by running the [MCP inspector](https://modelcontextprotocol.io/docs/tools/inspector):

```bash
npx @modelcontextprotocol/inspector ./bin/bundler_mcp

# with a logfile
BUNDLER_MCP_LOGFILE=/tmp/log/mcp.log npx @modelcontextprotocol/inspector ./bin/bundler_mcp
```

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/subelsky/bundler_mcp.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
