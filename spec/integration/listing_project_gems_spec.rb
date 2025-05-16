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
    gem_list = request("list_project_gems")

    expect(gem_list.size).to eq(55)
    expect(gem_list).to all include(:name, :version, :description, :full_gem_path)

    bundler_mcp = gem_list.find do |gem|
      gem.fetch(:name) == "bundler_mcp"
    end

    expect(bundler_mcp).to include(version: BundlerMCP::VERSION)
  end
end
