# frozen_string_literal: true

require "mcp/tool"

module BundlerMCP
  module Tools
    # Informs the client of all bundled Ruby gems with their versions, descriptions, installation paths,
    # documentation, and (optionally) source code locations
    # @see https://github.com/yjacquin/fast-mcp/blob/main/docs/tools.md
    class ListProjectGems < FastMcp::Tool
      description <<~DESC
        Lists **all** Ruby Gems declared in this project's Gemfile/Gemfile.lock, returning for each gem:
        name, version, short description, install path, and top-level docs path.

        ‣ Use this tool whenever you need to know about the project's gem dependencies and how they work.
        ‣ This tool reads local files only, so the data is authoritative for the current workspace
          and never relies on the Internet.
      DESC

      # @return [String] Tool name exposed by FastMCP to clients
      def self.name
        "list_project_gems"
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
