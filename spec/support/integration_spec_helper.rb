# frozen_string_literal: true

module IntegrationSpecHelper
  attr_accessor :read_io, :write_io, :child_pid

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

  def teardown_server
    write_io&.close
    read_io&.close

    return unless child_pid

    Process.kill("TERM", child_pid)
    Process.wait(child_pid)
  end
end
