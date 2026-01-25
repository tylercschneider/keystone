# frozen_string_literal: true

require "spec_helper"
require_relative "../../../app/components/keystone/ui/table_component"

RSpec.describe Keystone::UI::TableComponent do
  it "normalizes headers and rows with default classes" do
    headers = ["Name", { label: "Quantity" }, { label: "Edit", sr_only: true }]
    rows = [["Apples", "2", { content: "Edit", classes: "custom-action" }]]

    component = described_class.new(headers: headers, rows: rows)

    expect(component.header_cells).to eq([
      {
        label: "Name",
        sr_only: false,
        classes: described_class::HEADER_CLASSES_FIRST,
        scope: "col"
      },
      {
        label: "Quantity",
        sr_only: false,
        classes: described_class::HEADER_CLASSES_MIDDLE,
        scope: "col"
      },
      {
        label: "Edit",
        sr_only: true,
        classes: described_class::HEADER_CLASSES_LAST,
        scope: "col"
      }
    ])

    expect(component.row_cells).to eq([
      [
        {
          content: "Apples",
          classes: described_class::ROW_CLASSES_FIRST,
          tag: "td"
        },
        {
          content: "2",
          classes: described_class::ROW_CLASSES_MIDDLE,
          tag: "td"
        },
        {
          content: "Edit",
          classes: "custom-action",
          tag: "td"
        }
      ]
    ])
  end
end
