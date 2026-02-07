# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::InputComponent do
  it "returns base classes for a default text input" do
    component = described_class.new(name: "search")

    expect(component.classes).to include("block w-full rounded-md border")
  end

  it "builds tag_options with type, name, and class" do
    component = described_class.new(name: "email", type: :email, placeholder: "you@example.com")
    options = component.tag_options

    expect(options[:type]).to eq("email")
    expect(options[:name]).to eq("email")
    expect(options[:placeholder]).to eq("you@example.com")
    expect(options).not_to have_key(:disabled)
  end

  it "includes number attributes when type is number" do
    component = described_class.new(name: "qty", type: :number, value: 1, min: 0, max: 100, step: 1)
    options = component.tag_options

    expect(options[:type]).to eq("number")
    expect(options[:value]).to eq(1)
    expect(options[:min]).to eq(0)
    expect(options[:max]).to eq(100)
    expect(options[:step]).to eq(1)
  end

  it "adds disabled classes and attribute when disabled" do
    component = described_class.new(name: "locked", disabled: true)

    expect(component.classes).to include(described_class::DISABLED_CLASSES)
    expect(component.tag_options[:disabled]).to be true
  end
end
