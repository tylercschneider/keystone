# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::TextareaComponent do
  it "returns base classes" do
    component = described_class.new(name: "notes")

    expect(component.classes).to include("block w-full rounded-md border")
  end

  it "defaults rows to 3" do
    component = described_class.new(name: "notes")

    expect(component.tag_options[:rows]).to eq(3)
  end

  it "builds tag_options with name, rows, and placeholder" do
    component = described_class.new(name: "bio", rows: 5, placeholder: "Tell us about yourself")
    options = component.tag_options

    expect(options[:name]).to eq("bio")
    expect(options[:rows]).to eq(5)
    expect(options[:placeholder]).to eq("Tell us about yourself")
  end

  it "adds disabled classes and attribute when disabled" do
    component = described_class.new(name: "locked", disabled: true)

    expect(component.classes).to include(described_class::DISABLED_CLASSES)
    expect(component.tag_options[:disabled]).to be true
  end
end
