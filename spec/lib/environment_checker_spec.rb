# frozen_string_literal: true

require "spec_helper"
require "bundler_mcp/environment_checker"

RSpec.describe BundlerMCP::EnvironmentChecker do
  describe ".check" do
    context "when Gemfile exists" do
      it "returns the Gemfile path" do
        expect(described_class.check!).to eq(Bundler.default_gemfile)
      end
    end

    context "when Gemfile does not exist" do
      before do
        allow(Bundler)
          .to receive_message_chain(:default_gemfile, :exist?) # rubocop:disable RSpec/MessageChain
          .and_return(false)
      end

      it "raises error" do
        expect do
          described_class.check!
        end.to raise_error(BundlerMCP::GemfileNotFound)
      end
    end
  end
end
