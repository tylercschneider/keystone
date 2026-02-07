# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::AlertComponent do
  it "returns info classes by default" do
    component = described_class.new(message: "FYI")

    expect(component.classes).to include(described_class::TYPE_CLASSES[:info])
  end
end
