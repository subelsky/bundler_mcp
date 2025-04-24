# frozen_string_literal: true

Pathname(__dir__).glob("tools/*.rb").each do |tool|
  require tool
end

module BundlerMCP
  # Contains all tools that can be used by the caller
  class ToolCollection
    # @yield [Tool] each MCP tool
    # @yieldparam tool [Tool] a tool in the collection
    def self.each(&)
      TOOLS.each(&)
    end

    TOOLS = BundlerMCP::Tools.constants.map { |c| BundlerMCP::Tools.const_get(c) }
    private_constant :TOOLS
  end
end
