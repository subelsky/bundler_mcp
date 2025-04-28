# frozen_string_literal: true

require "bundler_mcp/tools/fetch_gem"
require "bundler_mcp/gem_resource"

RSpec.describe BundlerMCP::Tools::FetchGem do
  subject(:tool) { described_class.new([gem_resource]) }

  let(:gem_resource) do
    instance_double(BundlerMCP::GemResource,
                    name: "rspec",
                    to_h: { name: "rspec", version: "3.12.0" })
  end

  describe ".name" do
    it "returns the tool name" do
      expect(described_class.name).to eq("fetch_gem")
    end
  end

  describe "#call" do
    context "when gem exists" do
      it "returns gem details" do
        result = tool.call(name: "rspec")
        expect(result).to eq(name: "rspec", version: "3.12.0")
      end

      it "forwards include_source to the gem resource" do
        tool.call(name: "rspec", include_source: true)
        expect(gem_resource).to have_received(:to_h).with(include_source: true)
      end
    end

    context "when gem doesn't exist" do
      it "returns error message" do
        result = tool.call(name: "nonexistent")
        expect(result).to eq(error: "Gem 'nonexistent' not found in bundle")
      end
    end
  end
end
