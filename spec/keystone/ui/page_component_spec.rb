# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::PageComponent do
  it "includes responsive padding by default" do
    component = described_class.new

    expect(component.classes).to include("px-4 sm:px-6 lg:px-8")
  end

  it "omits padding when padding: :none" do
    component = described_class.new(padding: :none)

    expect(component.classes).not_to include("px-4")
  end

  it "maps each max_width value to the correct Tailwind class" do
    expect(described_class.new(max_width: :sm).classes).to include("max-w-2xl")
    expect(described_class.new(max_width: :md).classes).to include("max-w-4xl")
    expect(described_class.new(max_width: :lg).classes).to include("max-w-6xl")
    expect(described_class.new(max_width: :xl).classes).to include("max-w-7xl")
  end

  it "adds mx-auto for centering when max_width is not :full" do
    component = described_class.new(max_width: :md)

    expect(component.classes).to include("mx-auto")
  end

  it "does not add mx-auto when max_width is :full" do
    component = described_class.new(max_width: :full)

    expect(component.classes).not_to include("mx-auto")
  end
end
