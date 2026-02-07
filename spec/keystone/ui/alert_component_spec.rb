# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::AlertComponent do
  it "returns info classes by default" do
    component = described_class.new(message: "FYI")

    expect(component.classes).to include(described_class::TYPE_CLASSES[:info])
  end

  it "maps each type to its variant classes" do
    %i[info success warning error].each do |type|
      component = described_class.new(message: "msg", type: type)
      expect(component.classes).to include(described_class::TYPE_CLASSES[type])
    end
  end

  it "exposes message_text" do
    component = described_class.new(message: "Item saved!")

    expect(component.message_text).to eq("Item saved!")
  end

  it "exposes title when provided" do
    component = described_class.new(message: "Could not save", title: "Error")

    expect(component.title?).to be true
    expect(component.title_text).to eq("Error")
  end

  it "returns false for title? when not provided" do
    component = described_class.new(message: "FYI")

    expect(component.title?).to be false
  end

  it "exposes dismissible? flag" do
    expect(described_class.new(message: "x", dismissible: true).dismissible?).to be true
    expect(described_class.new(message: "x").dismissible?).to be false
  end
end
