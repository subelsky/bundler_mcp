# frozen_string_literal: true

require_relative "gem_resource"
require "singleton"

module BundlerMCP
  # Represents a collection of GemResource objects defining all currently bundled gems
  # @see GemResource
  class ResourceCollection
    include Singleton
    include Enumerable

    def initialize
      @resources = []

      Bundler.load.specs.each do |spec|
        resources << GemResource.new(spec)
      end
    end

    # Iterate over all GemResource objects in the collection
    # @yield [GemResource] each GemResource object in the collection
    def each(&)
      resources.each(&)
    end

    private

    attr_reader :resources
  end
end
