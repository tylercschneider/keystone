# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::CardLinkComponent do
  it "includes block, border, bg, padding, shadow, radius, and hover by default" do
    component = described_class.new(href: "/test")

    classes = component.classes
    expect(classes).to include("block")
    expect(classes).to include("rounded-lg")
    expect(classes).to include("border")
    expect(classes).to include("border-gray-200")
    expect(classes).to include("bg-white")
    expect(classes).to include("p-4")
    expect(classes).to include("shadow-sm")
    expect(classes).to include("hover:border-indigo-500")
    expect(classes).to include("dark:border-zinc-700")
    expect(classes).to include("dark:bg-zinc-900")
  end

  it "stores the href" do
    component = described_class.new(href: "/people/1")

    expect(component.href).to eq("/people/1")
  end

  it "maps each padding size correctly" do
    expect(described_class.new(href: "/", padding: :sm).classes).to include("p-3")
    expect(described_class.new(href: "/", padding: :md).classes).to include("p-4")
    expect(described_class.new(href: "/", padding: :lg).classes).to include("p-6")
  end

  it "omits shadow-sm when shadow: false" do
    component = described_class.new(href: "/", shadow: false)

    expect(component.classes).not_to include("shadow-sm")
  end

  it "always includes dark mode and hover classes" do
    component = described_class.new(href: "/")

    expect(component.classes).to include("dark:bg-zinc-900")
    expect(component.classes).to include("dark:border-zinc-700")
    expect(component.classes).to include("hover:border-indigo-500")
  end
end
