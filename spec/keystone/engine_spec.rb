# frozen_string_literal: true

RSpec.describe "KeystoneComponents::Engine" do
  let(:source) { File.read(File.expand_path("../../lib/keystone_components/engine.rb", __dir__)) }

  it "does not reference theme CSS files" do
    expect(source).not_to include("themes/base.css")
    expect(source).not_to include("themes/dark.css")
  end

  it "injects @source path via initializer during app boot" do
    expect(source).to include("keystone_components.tailwind_source")
    expect(source).to include("keystone:source")
    expect(source).to include("app/components/**/*.{erb,rb}")
  end
end
