# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::FormFieldComponent do
  it "infers label text from attribute name" do
    component = described_class.new(attribute: :first_name)

    expect(component.label_text).to eq("First name")
  end
end
