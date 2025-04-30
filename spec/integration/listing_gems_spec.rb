# frozen_string_literal: true

require "spec_helper"
require "json"
require "timeout"

# rubocop:disable RSpec/InstanceVariable

RSpec.describe "Listing gems" do
  let(:server_executable) do
    File.expand_path("../../exe/bundler_mcp", __dir__)
  end

  let(:read_io) { nil }
  let(:write_io) { nil }
  let(:child_pid) { nil }

  before do
    input_read, input_write = IO.pipe
    output_read, output_write = IO.pipe

    @child_pid = fork do
      # Child process - will run the server
      input_write.close
      output_read.close

      # Redirect stdin/stdout to our pipes
      $stdin.reopen(input_read)
      $stdout.reopen(output_write)

      # Close unused pipe ends
      input_read.close
      output_write.close

      # Run the server
      load server_executable
    end

    # Parent process - will run the tests
    input_read.close
    output_write.close

    @write_io = input_write
    @read_io = output_read
  end

  after do
    @write_io&.close
    @read_io&.close

    if @child_pid
      Process.kill("TERM", @child_pid)
      Process.wait(@child_pid)
    end
  end

  it "returns a list of gems via MCP protocol" do
    request = {
      jsonrpc: "2.0",
      id: 2,
      method: "tools/call",
      params: {
        name: "list_gems"
      }
    }.to_json

    @write_io.puts(request)

    response = JSON.parse(@read_io.gets, symbolize_names: true)
    text = response.dig(:result, :content, 0, :text)

    gem_list = JSON.parse(text, symbolize_names: true)

    expect(gem_list.size).to eq(55)
    expect(gem_list).to all include(:name, :version, :description, :full_gem_path)

    bundler_mcp = gem_list.find do |gem|
      gem.fetch(:name) == "bundler_mcp"
    end

    expect(bundler_mcp).to include(version: BundlerMCP::VERSION)
  end
end

# rubocop:enable RSpec/InstanceVariable
