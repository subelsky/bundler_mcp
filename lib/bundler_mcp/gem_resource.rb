# frozen_string_literal: true

require "forwardable"
require "pathname"

module BundlerMCP
  # Represents a Ruby gem and its associated data
  # @see https://docs.ruby-lang.org/en/2.5.0/Gem/Specification.html
  class GemResource
    extend Forwardable

    def_delegators :gem, :name, :description, :full_gem_path

    # @param gem [Gem::Specification]
    def initialize(gem)
      @gem = gem

      @version = gem.version.to_s
      @base_path = Pathname(@gem.full_gem_path)
      @doc_paths = @base_path.glob("{README,CHANGELOG}*").map!(&:to_s)
      @lib_path = @base_path.join("lib").to_s
    end

    # @return [Hash] A hash containing the gem's details
    def to_h(include_source_files: false)
      base_hash = { name:,
                    version:,
                    description:,
                    full_gem_path:,
                    lib_path:,
                    top_level_documentation_paths: doc_paths }

      base_hash[:source_files] = @base_path.glob("**/*.{rb,c,rake}").map!(&:to_s) if include_source_files

      base_hash
    end

    private

    attr_reader :gem, :version, :base_path, :doc_paths, :lib_path
  end
end
