# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::FormFieldComponent do
  it "infers label text from attribute name" do
    component = described_class.new(attribute: :first_name)

    expect(component.label_text).to eq("First name")
  end

  it "uses explicit label when provided" do
    component = described_class.new(attribute: :name, label: "List Name")

    expect(component.label_text).to eq("List Name")
  end

  it "exposes required? flag" do
    expect(described_class.new(attribute: :name, required: true).required?).to be true
    expect(described_class.new(attribute: :name).required?).to be false
  end

  it "exposes hint? and hint_text" do
    component = described_class.new(attribute: :name, hint: "Enter a descriptive name")

    expect(component.hint?).to be true
    expect(component.hint_text).to eq("Enter a descriptive name")
  end

  it "returns false for hint? when no hint" do
    component = described_class.new(attribute: :name)

    expect(component.hint?).to be false
  end

  it "detects textarea type" do
    expect(described_class.new(attribute: :bio, type: :textarea).textarea?).to be true
    expect(described_class.new(attribute: :name, type: :text).textarea?).to be false
  end

  it "builds input_options with type and placeholder" do
    component = described_class.new(attribute: :email, type: :email, placeholder: "you@example.com")
    options = component.input_options

    expect(options[:name]).to eq("email")
    expect(options[:type]).to eq("email")
    expect(options[:placeholder]).to eq("you@example.com")
  end

  it "omits type from input_options for textarea" do
    component = described_class.new(attribute: :bio, type: :textarea)

    expect(component.input_options).not_to have_key(:type)
  end

  it "includes min and max for number inputs" do
    component = described_class.new(attribute: :quantity, type: :number, min: 1, max: 100)
    options = component.input_options

    expect(options[:min]).to eq(1)
    expect(options[:max]).to eq(100)
  end
end
