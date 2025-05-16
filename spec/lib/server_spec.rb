# frozen_string_literal: true

require "spec_helper"
require "bundler_mcp/server"

RSpec.describe BundlerMCP::Server do
  before do
    allow(BundlerMCP::EnvironmentChecker).to receive(:check!)
    allow(FastMcp::Server).to receive(:new).and_return(mcp_server)
  end

  let(:mcp_server) do
    instance_double(FastMcp::Server,
                    register_tool: nil,
                    start: nil)
  end

  describe ".run" do
    it "checks the environment" do
      described_class.run
      expect(BundlerMCP::EnvironmentChecker).to have_received(:check!)
    end

    it "registers all tools" do
      described_class.run

      expect(mcp_server)
        .to have_received(:register_tool)
        .with(BundlerMCP::Tools::ListProjectGems)
        .with(BundlerMCP::Tools::GetGemDetails)
    end

    it "starts the server" do
      described_class.run
      expect(mcp_server).to have_received(:start)
    end

    context "when an error occurs" do
      let(:error) { BundlerMCP::GemfileNotFound }

      before do
        allow(BundlerMCP::EnvironmentChecker)
          .to receive(:check!)
          .and_raise(error)
      end

      it "re-raises the error" do
        expect do
          described_class.run
        end.to raise_error(error)
      end
    end
  end
end
