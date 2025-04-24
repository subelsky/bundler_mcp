# frozen_string_literal: true

require "bundler"
require "bundler_mcp"

module BundlerMCP
  # Responsible for checking the environment to make sure Bundler can find gems
  class EnvironmentChecker
    # Check for a Gemfile and raise an error if not found
    # @return [Pathname] The path to the Gemfile
    # @raise [GemfileNotFound]
    #   If Bundler cannot find a Gemfile; can be avoided by setting BUNDLE_GEMFILE
    def self.check!
      raise GemfileNotFound unless Bundler.default_gemfile.exist?

      Bundler.default_gemfile
    end
  end
end
