# frozen_string_literal: true

require "bundler"
require "fast_mcp"
require "json"
require "pathname"
require "logger"
require_relative "version"
require_relative "resource_collection"
require_relative "tool_collection"
require_relative "environment_checker"

module BundlerMCP
  # Main server class for BundlerMCP
  # @see https://github.com/yjacquin/fast-mcp/blob/main/examples/server_with_stdio_transport.rb
  class Server
    # Convenience method to start the server
    # @return [void]
    def self.run(**args)
      new(**args).run
    end

    # Initialize the server
    # @return [void]
    def initialize(logger: Logger.new(File::NULL))
      @logger = logger

      @server = FastMcp::Server.new(
        name: "bundler-gem-documentation",
        version: VERSION
      )
    end

    # Start the MCP server
    # @return [void]
    def run
      gemfile_path = EnvironmentChecker.check!
      logger.info "Starting BundlerMCP server with Gemfile: #{gemfile_path}"

      ToolCollection.each do |tool|
        server.register_tool(tool)
      end

      server.start
    rescue StandardError => e
      logger.error e.message
      raise e
    end

    private

    attr_reader :logger, :server
  end
end
