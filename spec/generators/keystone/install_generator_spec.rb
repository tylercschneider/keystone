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

  it "has a setup_tailwind method" do
    expect(described_class.instance_methods).to include(:setup_tailwind)
  end

  it "uses a marker comment for build-time source injection" do
    expect(described_class::SOURCE_MARKER).to eq("/* keystone:source */")
  end

  it "does not inject local gem paths" do
    source = File.read(File.expand_path("../../../lib/generators/keystone/install_generator.rb", __dir__))
    expect(source).not_to include("Engine.root")
  end

  it "anchors injection after @import tailwindcss" do
    expect(described_class::TAILWIND_IMPORT).to eq('@import "tailwindcss";')
  end

  it "has a generate_claude_docs method" do
    expect(described_class.instance_methods).to include(:generate_claude_docs)
  end
end
