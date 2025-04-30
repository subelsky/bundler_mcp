# frozen_string_literal: true

require "spec_helper"
require "bundler_mcp/gem_resource"
require "bundler_mcp/resource_collection"

RSpec.describe BundlerMCP::ResourceCollection do
  let(:gem) do
    Bundler.load.specs.find { |s| s.name == "bundler_mcp" }
  end

  describe "#each" do
    it "yields each gem" do
      expect do |b|
        described_class.instance.each(&b)
      end
        .to yield_control
        .exactly(55)
        .times
    end

    it "yields GemResource instances" do
      expect(described_class.instance).to all be_a(BundlerMCP::GemResource)
    end
  end
end
