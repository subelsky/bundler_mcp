# frozen_string_literal: true

require "spec_helper"
require "json"
require "timeout"

RSpec.describe "Listing gems" do
  around do |example|
    setup_server
    example.run
    teardown_server
  end

  it "returns a list of gems via MCP protocol" do
    request = {
      jsonrpc: "2.0",
      id: 2,
      method: "tools/call",
      params: {
        name: "list_gems"
      }
    }.to_json

    write_io.puts(request)

    response = JSON.parse(read_io.gets, symbolize_names: true)
    text = response.dig(:result, :content, 0, :text)

    gem_list = JSON.parse(text, symbolize_names: true)

    expect(gem_list.size).to eq(55)
    expect(gem_list).to all include(:name, :version, :description, :full_gem_path)

    bundler_mcp = gem_list.find do |gem|
      gem.fetch(:name) == "bundler_mcp"
    end

    expect(bundler_mcp).to include(version: BundlerMCP::VERSION)
  end
end
