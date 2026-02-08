# frozen_string_literal: true

RSpec.describe "KeystoneComponents::Engine" do
  let(:source) { File.read(File.expand_path("../../lib/keystone_components/engine.rb", __dir__)) }
  let(:rake_source) { File.read(File.expand_path("../../lib/tasks/keystone_components.rake", __dir__)) }

  it "does not reference theme CSS files" do
    expect(source).not_to include("themes/base.css")
    expect(source).not_to include("themes/dark.css")
  end

  it "defines rake tasks to inject and clean @source path" do
    expect(rake_source).to include("keystone:inject_source")
    expect(rake_source).to include("keystone:clean_source")
  end

  it "enhances tailwindcss:build with inject and clean tasks" do
    expect(rake_source).to include("tailwindcss:build")
    expect(rake_source).to include("keystone:inject_source")
    expect(rake_source).to include("keystone:clean_source")
  end
end
