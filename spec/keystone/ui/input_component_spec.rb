# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::InputComponent do
  it "returns base classes for a default text input" do
    component = described_class.new(name: "search")

    expect(component.classes).to include("block w-full rounded-md border")
  end
end
