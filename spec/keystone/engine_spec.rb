# frozen_string_literal: true

RSpec.describe "KeystoneComponents::Engine" do
  let(:source) { File.read(File.expand_path("../../lib/keystone_components/engine.rb", __dir__)) }

  it "does not reference theme CSS files" do
    expect(source).not_to include("themes/base.css")
    expect(source).not_to include("themes/dark.css")
  end

  it "defines a rake task to inject @source path before Tailwind builds" do
    expect(source).to include("keystone:inject_source")
    expect(source).to include("tailwindcss:build")
  end

  it "restores marker-only line after Tailwind build so no local path is committed" do
    expect(source).to include("keystone:clean_source")
  end
end
