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
    gem_details = request("fetch_gem", name: "bundler_mcp")

    expect(gem_details).to include(
      name: "bundler_mcp",
      version: BundlerMCP::VERSION,
      description: be_a(String),
      full_gem_path: be_a(String)
    )
  end

  it "returns an error for non-existent gems" do
    response = request("fetch_gem", name: "non_existent_gem_123")
    expect(response).to include(error: "We could not find 'non_existent_gem_123' among the project's bundled gems")
  end

  context "with the include_source flag" do
    it "returns gem details with source code paths" do
      gem_details = request("fetch_gem", name: "bundler_mcp", include_source: true)
      gem_details => { source_files: }

      expect(source_files).to include(end_with("bundler_mcp/lib/bundler_mcp.rb"))
    end
  end
end
