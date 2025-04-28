# frozen_string_literal: true

require_relative "lib/bundler_mcp/version"

EXCLUDE_FILES = %w[
  bin/ test/ spec/ features/ .git .github .cursor .cursorignore
  .rspec .rubocop.yml example.mcp.json Gemfile
].freeze

Gem::Specification.new do |spec|
  spec.name = "bundler_mcp"
  spec.version = BundlerMCP::VERSION
  spec.authors = ["Mike Subelsky"]
  spec.email = ["12020+subelsky@users.noreply.github.com"]

  spec.summary = "MCP server for searching Ruby bundled gem documentation and metadata"

  spec.description = <<~DESC
    A Model Context Protocol (MCP) server that enables AI agents to query information
    about gems in a Ruby project's Gemfile, including source code and metadata.
  DESC

  spec.homepage = "https://github.com/subelsky/bundler_mcp"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"
  spec.metadata["keywords"] = "mcp gems bundler"

  gemspec = File.basename(__FILE__)

  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) || f.start_with?(*EXCLUDE_FILES)
    end
  end

  spec.bindir = "exe"
  spec.executables = ["bundler_mcp"]

  spec.require_paths = ["lib"]

  spec.add_dependency "bundler", "~> 2.6"
  spec.add_dependency "fast-mcp", "~> 1.3"
end
