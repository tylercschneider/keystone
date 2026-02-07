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
    expect(described_class.new(gap: :xl).classes).to include("gap-8")
  end

  it "uses split gap classes when gap_x and gap_y are provided" do
    component = described_class.new(cols: { default: 1, sm: 6 }, gap_x: :lg, gap_y: :xl)

    expect(component.classes).to include("gap-x-6")
    expect(component.classes).to include("gap-y-8")
    expect(component.classes).not_to include("gap-4")
  end

  it "uses gap_x only when gap_y is not provided" do
    component = described_class.new(gap_x: :md)

    expect(component.classes).to include("gap-x-4")
    expect(component.classes).not_to include("gap-y")
    expect(component.classes).not_to include("gap-4")
  end

  it "uses gap_y only when gap_x is not provided" do
    component = described_class.new(gap_y: :lg)

    expect(component.classes).to include("gap-y-6")
    expect(component.classes).not_to include("gap-x")
    expect(component.classes).not_to include("gap-4")
  end

  it "ignores gap when gap_x or gap_y is provided" do
    component = described_class.new(gap: :sm, gap_x: :lg, gap_y: :xl)

    expect(component.classes).to include("gap-x-6")
    expect(component.classes).to include("gap-y-8")
    expect(component.classes).not_to include("gap-3")
  end

  it "defines COL_CLASSES with static class strings for each breakpoint" do
    col_classes = described_class::COL_CLASSES

    expect(col_classes[:default][1]).to eq("grid-cols-1")
    expect(col_classes[:default][12]).to eq("grid-cols-12")
    expect(col_classes[:sm][2]).to eq("sm:grid-cols-2")
    expect(col_classes[:md][6]).to eq("md:grid-cols-6")
    expect(col_classes[:lg][4]).to eq("lg:grid-cols-4")
  end

  it "raises KeyError for unsupported column counts" do
    expect {
      described_class.new(cols: { default: 99 }).classes
    }.to raise_error(KeyError)
  end
end
