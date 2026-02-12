# frozen_string_literal: true

RSpec.describe "engine.css" do
  let(:css) { File.read(File.expand_path("../../app/assets/tailwind/keystone_ui_engine/engine.css", __dir__)) }

  it "contains a @source inline safelist with grid-cols classes" do
    expect(css).to include("@source inline(")
    expect(css).to include("grid-cols-1")
    expect(css).to include("grid-cols-12")
    expect(css).to include("sm:grid-cols-1")
    expect(css).to include("lg:grid-cols-12")
  end
end
