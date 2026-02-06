# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::PanelComponent do
  it "includes border, bg, padding, shadow, and radius by default" do
    component = described_class.new

    classes = component.classes
    expect(classes).to include("rounded-xl")
    expect(classes).to include("border")
    expect(classes).to include("border-gray-200")
    expect(classes).to include("bg-white")
    expect(classes).to include("p-5")
    expect(classes).to include("shadow-sm")
    expect(classes).to include("dark:bg-zinc-900")
    expect(classes).to include("dark:border-zinc-700")
  end

  it "maps each padding size correctly" do
    expect(described_class.new(padding: :sm).classes).to include("p-4")
    expect(described_class.new(padding: :md).classes).to include("p-5")
    expect(described_class.new(padding: :lg).classes).to include("p-6")
  end

  it "maps each radius size correctly" do
    expect(described_class.new(radius: :md).classes).to include("rounded-lg")
    expect(described_class.new(radius: :lg).classes).to include("rounded-xl")
    expect(described_class.new(radius: :xl).classes).to include("rounded-2xl")
  end

  it "omits shadow-sm when shadow: false" do
    component = described_class.new(shadow: false)

    expect(component.classes).not_to include("shadow-sm")
  end

  it "always includes dark mode classes" do
    component = described_class.new

    expect(component.classes).to include("dark:bg-zinc-900")
    expect(component.classes).to include("dark:border-zinc-700")
  end
end
