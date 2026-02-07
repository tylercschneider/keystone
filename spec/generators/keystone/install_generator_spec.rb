# frozen_string_literal: true

unless defined?(Rails)
  module Rails
    module Generators
      class Base
        def self.desc(description = nil)
          @desc = description if description
          @desc
        end

        def self.source_root(path = nil)
          @source_root = path if path
          @source_root
        end
      end
    end
  end
end

require_relative "../../../lib/generators/keystone/install_generator"

RSpec.describe Keystone::InstallGenerator do
  it "inherits from Rails::Generators::Base" do
    expect(described_class.superclass).to eq(Rails::Generators::Base)
  end

  it "has a setup_instructions method" do
    expect(described_class.instance_methods).to include(:setup_instructions)
  end

  it "uses the correct tailwindcss-rails engine import path" do
    expect(described_class::IMPORT_LINE).to eq('@import "../builds/tailwind/keystone_components_engine";')
  end

  it "has a generate_claude_docs method" do
    expect(described_class.instance_methods).to include(:generate_claude_docs)
  end
end
