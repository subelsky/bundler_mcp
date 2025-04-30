# frozen_string_literal: true

require "bundler_mcp/tools/list_gems"
require "bundler_mcp/gem_resource"

RSpec.describe BundlerMCP::Tools::ListGems do
  subject(:tool) { described_class.new(gem_resources) }

  let(:gem_resources) do
    [
      instance_double(BundlerMCP::GemResource,
                      to_h: { name: "rspec", version: "3.12.0" }),
      instance_double(BundlerMCP::GemResource,
                      to_h: { name: "rails", version: "7.1.0" })
    ]
  end

  describe ".name" do
    it "returns the tool name" do
      expect(described_class.name).to eq("list_gems")
    end
  end

  describe "#call" do
    it "returns a JSON array of gem details" do
      result = JSON.parse(tool.call, symbolize_names: true)
      expect(result).to eq([
                             { name: "rspec", version: "3.12.0" },
                             { name: "rails", version: "7.1.0" }
                           ])
    end
  end
end
