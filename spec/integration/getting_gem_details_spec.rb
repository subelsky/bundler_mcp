# frozen_string_literal: true

require "spec_helper"
require "json"
require "timeout"

RSpec.describe "Fetching a gem" do
  around do |example|
    setup_server
    example.run
    teardown_server
  end

  it "returns gem details via MCP protocol" do
    gem_details = request("get_gem_details", name: "bundler_mcp")

    expect(gem_details).to include(
      name: "bundler_mcp",
      version: BundlerMCP::VERSION,
      description: be_a(String),
      full_gem_path: end_with("bundler_mcp"),
      lib_path: end_with("bundler_mcp/lib"),
      top_level_documentation_paths: include(end_with("bundler_mcp/README.md")),
      source_files: include(end_with("bundler_mcp/lib/bundler_mcp.rb"))
    )
  end

  it "returns an error for non-existent gems" do
    response = request("get_gem_details", name: "non_existent_gem_123")
    expect(response).to include(error: "We could not find 'non_existent_gem_123' among the project's bundled gems")
  end
end
