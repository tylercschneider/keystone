# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::PageHeaderComponent do
  it "exposes title" do
    component = described_class.new(title: "Shopping Lists")

    expect(component.title).to eq("Shopping Lists")
  end
end
