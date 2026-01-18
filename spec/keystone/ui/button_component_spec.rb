# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::UI::ButtonComponent do
  it "combines base, variant, and size classes" do
    component = described_class.new(label: "Create invoice", variant: :secondary, size: :lg)

    expect(component.classes).to eq("ui-button ui-button--secondary ui-button--lg")
  end

  it "adds a button type when rendering a button element" do
    component = described_class.new(label: "Create invoice")

    expect(component.tag_options[:type]).to eq("button")
  end
end
