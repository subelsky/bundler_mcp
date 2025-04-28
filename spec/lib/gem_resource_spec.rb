# frozen_string_literal: true

require "bundler_mcp/gem_resource"
require "rubygems"

RSpec.describe BundlerMCP::GemResource do
  subject(:resource) { described_class.new(gem_spec) }

  let(:gem_spec) { Gem::Specification.find_by_name("bundler_mcp") }

  describe "#to_h" do
    let(:result) { resource.to_h(include_source: false) }

    context "without source files" do
      it "returns basic gem details" do
        aggregate_failures do
          expect(result).to include(
            name: "bundler_mcp",
            version: BundlerMCP::VERSION,
            description: gem_spec.description,
            full_gem_path: gem_spec.full_gem_path,
            lib_path: File.join(gem_spec.full_gem_path, "lib")
          )

          expect(result.fetch(:top_level_documentation_paths)).to include(
            File.join(gem_spec.full_gem_path, "README.md")
          )
        end
      end
    end

    context "with source files" do
      let(:result) { resource.to_h(include_source: true) }

      it "includes source file paths" do
        expect(result.fetch(:source_files)).to include(
          File.join(gem_spec.full_gem_path, "lib/bundler_mcp/gem_resource.rb")
        )
      end
    end
  end
end
