# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::GridComponent do
  it "defaults to grid gap-4 grid-cols-1" do
    component = described_class.new

    expect(component.classes).to eq("grid gap-4 grid-cols-1")
  end

  it "builds responsive column classes for multiple breakpoints" do
    component = described_class.new(cols: { default: 1, sm: 2, lg: 4 })

    expect(component.classes).to include("grid-cols-1")
    expect(component.classes).to include("sm:grid-cols-2")
    expect(component.classes).to include("lg:grid-cols-4")
  end

  it "maps each gap size correctly" do
    expect(described_class.new(gap: :sm).classes).to include("gap-3")
    expect(described_class.new(gap: :md).classes).to include("gap-4")
    expect(described_class.new(gap: :lg).classes).to include("gap-6")
  end
end
