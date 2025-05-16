# frozen_string_literal: true

require "fast_mcp"

module BundlerMCP
  module Tools
    # Retrieve details about a specific bundled Ruby gem
    # @see ResourceCollection
    class FetchGem < FastMcp::Tool
      description <<~DESC
        Retrieve a specific bundled Ruby gem with version, description, installation path,
        source code locations, and top-level documentation locations
      DESC

      arguments do
        required(:name).filled(:string).description("The name of the gem to fetch")
        optional(:include_source).filled(:bool).description("Include source code paths in results")
      end

      # @return [String] Tool name exposed by FastMCP to clients
      def self.name
        "fetch_gem"
      end

      # @param collection [ResourceCollection] contains installed gems
      def initialize(collection = ResourceCollection.instance)
        @resource_collection = collection
        super()
      end

      # @param name [String] The name of the gem to fetch
      # @param include_source [Boolean]
      #   Whether to include source code paths in results; this can increase
      #   the size of the response and eat into context window limits
      # @return [Hash] Contains the gem's details, or an error message if the gem is not found
      def call(name:, include_source: false)
        name = name.to_s.strip
        gem_resource = resource_collection.find { |r| r.name == name }

        data = if gem_resource
                 gem_resource.to_h(include_source:)
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
