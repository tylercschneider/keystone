# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::TextareaComponent do
  it "returns base classes" do
    component = described_class.new(name: "notes")

    expect(component.classes).to include("block w-full rounded-md border")
  end
end
