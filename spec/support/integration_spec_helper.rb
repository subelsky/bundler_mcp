# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize,Metrics/MethodLength

module IntegrationSpecHelper
  attr_accessor :read_io, :write_io, :child_pid

  # Forks so that we can test the server's behavior in isolation using STDIN/STDOUT.
  # We use IO.pipe to create a pair of pipes, one for reading and one for writing.
  def setup_server
    input_read, input_write = IO.pipe
    output_read, output_write = IO.pipe

    self.child_pid = fork do
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
      server_executable = File.expand_path("../../exe/bundler_mcp", __dir__)
      load server_executable
    end

    # Parent process - will run the tests
    input_read.close
    output_write.close

    self.read_io = output_read
    self.write_io = input_write

    [read_io, write_io]
  end

  # Closes the pipes and kills the child process.
  def teardown_server
    write_io&.close
    read_io&.close

    return unless child_pid

    Process.kill("TERM", child_pid)
    Process.wait(child_pid)
  end

  # Sends a request to the server and returns the response.
  # @param method [String] The name of the tool to call
  # @param arguments [Hash] Tool-specific arguments to pass as part of the tool call
  # @return [Hash] The response from the server
  def request(method, **arguments)
    request = RPC_ARGUMENTS.merge(
      params: {
        name: method,
        arguments: arguments
      }
    ).to_json

    write_io.puts(request)

    response = JSON.parse(read_io.gets, symbolize_names: true)
    text = response.dig(:result, :content, 0, :text)

    JSON.parse(text, symbolize_names: true)
  end

  RPC_ARGUMENTS = {
    jsonrpc: "2.0",
    method: "tools/call"
  }.freeze

  private_constant :RPC_ARGUMENTS
end

# rubocop:enable Metrics/AbcSize,Metrics/MethodLength
