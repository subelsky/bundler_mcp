# frozen_string_literal: true

require "mcp/tool"

module BundlerMCP
  module Tools
    # Informs the client of all bundled Ruby gems with their versions, descriptions, installation paths,
    # documentation, and (optionally) source code locations
    # @see https://github.com/yjacquin/fast-mcp/blob/main/docs/tools.md
    class ListGems < FastMcp::Tool
      description <<~DESC
        List all bundled Ruby gems with their versions, descriptions, installation paths,
        and top-level documentation locations
      DESC

      # @return [String] Tool name exposed by FastMCP to clients
      def self.name
        "list_gems"
      end

      # @param collection [ResourceCollection] contains installed gems
      def initialize(collection = ResourceCollection.instance)
        @resource_collection = collection
        super()
      end

      # Invoke the tool to list all installed gems
      # @return [Array<Hash>] An array of hashes containing gem details
      def call
        data = resource_collection.map(&:to_h)
        JSON.generate(data)
      end

      private

      attr_reader :resource_collection
    end
  end
end
