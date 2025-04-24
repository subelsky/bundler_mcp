# frozen_string_literal: true

require_relative "bundler_mcp/version"

# Namespace for BundlerMCP code
module BundlerMCP
  # Base error class for BundlerMCP
  Error = Class.new(StandardError)

  # Raised when Bundler cannot find a Gemfile
  class GemfileNotFound < Error
    def initialize(msg = DEFAULT_MESSAGE)
      super
    end

    DEFAULT_MESSAGE = "Bundler cannot find a Gemfile; try setting BUNDLE_GEMFILE"
  end
end
