# frozen_string_literal: true

require "fast_mcp"

module BundlerMCP
  module Tools
    # Retrieve details about a specific bundled Ruby gem
    # @see ResourceCollection
    class GetGemDetails < FastMcp::Tool
      description <<~DESC
        Returns detailed information about one **Ruby Gem** that is installed in the current project.

        ‣ Use this tool when you need to know the version, summary, or source code location for a gem that is installed in the current project.
        ‣ Do **not** use it for gems that are *not* part of this project.

        The data comes directly from Gemfile.lock and the local installation, so it is always up-to-date and requires **no Internet access**.
      DESC

      arguments do
        required(:name).filled(:string).description("The name of the gem to fetch")
      end

      # @return [String] Tool name exposed by FastMCP to clients
      def self.name = "get_gem_details"

      # @param collection [ResourceCollection] contains installed gems
      def initialize(collection = ResourceCollection.instance)
        @resource_collection = collection
        super()
      end

      # @param name [String] The name of the gem to fetch
      # @return [Hash] Contains the gem's details, or an error message if the gem is not found
      def call(name:)
        name = name.to_s.strip
        gem_resource = resource_collection.find { |r| r.name == name }

        data = if gem_resource
                 gem_resource.to_h(include_source_files: true)
               else
                 { error: "We could not find '#{name}' among the project's bundled gems" }
               end

        JSON.generate(data)
      end

      private

      attr_reader :resource_collection
    end
  end
end
