# frozen_string_literal: true

require "bundler_mcp/tools/get_gem_details"
require "bundler_mcp/gem_resource"

RSpec.describe BundlerMCP::Tools::GetGemDetails do
  subject(:tool) { described_class.new([gem_resource]) }

  let(:gem_resource) do
    instance_double(BundlerMCP::GemResource,
                    name: "rspec",
                    to_h: { name: "rspec", version: "3.12.0" })
  end

  describe ".name" do
    it "returns the tool name" do
      expect(described_class.name).to eq("get_gem_details")
    end
  end

  describe "#call" do
    it "returns gem details" do
      response = tool.call(name: "rspec")
      result = JSON.parse(response, symbolize_names: true)

      expect(result).to eq(name: "rspec", version: "3.12.0")
    end

    context "when gem doesn't exist" do
      it "returns error message" do
        response = tool.call(name: "nonexistent")
        result = JSON.parse(response, symbolize_names: true)

        expect(result).to eq(error: "We could not find 'nonexistent' among the project's bundled gems")
      end
    end
  end
end
