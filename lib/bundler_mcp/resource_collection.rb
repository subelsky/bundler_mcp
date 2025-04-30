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

      Gem.loaded_specs.each_value do |spec|
        # Returns most gems as Bundler::StubSpecification, which does not expose
        # many gem details, so we convert to Gem::Specification
        spec = Gem::Specification.find_by_name(spec.name)
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
