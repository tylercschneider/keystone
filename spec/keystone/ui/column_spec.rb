# frozen_string_literal: true

require "spec_helper"
require_relative "../../../app/components/keystone/ui/column"

RSpec.describe Keystone::Ui::Column do
  it "exposes key and header_text" do
    column = described_class.new(:name, "Name")

    expect(column.key).to eq(:name)
    expect(column.header_text).to eq("Name")
  end

  it "defaults mobile_hidden? to false" do
    column = described_class.new(:name, "Name")
    expect(column.mobile_hidden?).to be false
  end

  it "accepts mobile_hidden: true" do
    column = described_class.new(:name, "Name", mobile_hidden: true)
    expect(column.mobile_hidden?).to be true
  end
end
