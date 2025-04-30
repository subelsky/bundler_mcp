# frozen_string_literal: true

require "bundler_mcp"
require "debug"

Dir[File.expand_path("support/**/*.rb", __dir__)].each do |file|
  require file
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.define_derived_metadata(file_path: %r{spec/integration/}) do |metadata|
    metadata[:integration] = true
  end

  config.include IntegrationSpecHelper, integration: true
end
