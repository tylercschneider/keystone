# frozen_string_literal: true

require "spec_helper"
require_relative "../../../app/components/keystone/ui/data_table_component"

RSpec.describe Keystone::Ui::DataTableComponent do
  let(:columns) { [{ name: "Name" }, { quantity: "Quantity" }, { price: "Price" }] }
  let(:hash_items) do
    [
      { name: "Apples", quantity: 10, price: "$1.50" },
      { name: "Bananas", quantity: 5, price: "$0.75" }
    ]
  end

  describe "#header_cells" do
    it "generates header cells from column labels with position-based classes" do
      component = described_class.new(items: hash_items, columns: columns)

      expect(component.header_cells).to eq([
        { label: "Name", classes: described_class::HEADER_CLASSES_FIRST, scope: "col" },
        { label: "Quantity", classes: described_class::HEADER_CLASSES_MIDDLE, scope: "col" },
        { label: "Price", classes: described_class::HEADER_CLASSES_LAST, scope: "col" }
      ])
    end

    it "assigns FIRST and LAST correctly for a 2-column layout" do
      two_columns = [{ name: "Name" }, { price: "Price" }]
      component = described_class.new(items: hash_items, columns: two_columns)

      expect(component.header_cells).to eq([
        { label: "Name", classes: described_class::HEADER_CLASSES_FIRST, scope: "col" },
        { label: "Price", classes: described_class::HEADER_CLASSES_LAST, scope: "col" }
      ])
    end
  end

  describe "#row_cells" do
    it "resolves values from hash items" do
      component = described_class.new(items: hash_items, columns: columns)

      expect(component.row_cells).to eq([
        [
          { value: "Apples", classes: described_class::ROW_CLASSES_FIRST },
          { value: 10, classes: described_class::ROW_CLASSES_MIDDLE },
          { value: "$1.50", classes: described_class::ROW_CLASSES_LAST }
        ],
        [
          { value: "Bananas", classes: described_class::ROW_CLASSES_FIRST },
          { value: 5, classes: described_class::ROW_CLASSES_MIDDLE },
          { value: "$0.75", classes: described_class::ROW_CLASSES_LAST }
        ]
      ])
    end

    it "resolves values from objects that respond to methods" do
      Product = Struct.new(:name, :quantity, :price, keyword_init: true)
      struct_items = [
        Product.new(name: "Widget", quantity: 20, price: "$9.99")
      ]

      component = described_class.new(items: struct_items, columns: columns)

      expect(component.row_cells).to eq([
        [
          { value: "Widget", classes: described_class::ROW_CLASSES_FIRST },
          { value: 20, classes: described_class::ROW_CLASSES_MIDDLE },
          { value: "$9.99", classes: described_class::ROW_CLASSES_LAST }
        ]
      ])
    end

    it "assigns position-based row classes correctly" do
      component = described_class.new(items: [hash_items.first], columns: columns)
      row = component.row_cells.first

      expect(row[0][:classes]).to eq(described_class::ROW_CLASSES_FIRST)
      expect(row[1][:classes]).to eq(described_class::ROW_CLASSES_MIDDLE)
      expect(row[2][:classes]).to eq(described_class::ROW_CLASSES_LAST)
    end
  end

  describe "#empty?" do
    it "returns true when items are empty" do
      component = described_class.new(items: [], columns: columns)
      expect(component.empty?).to be true
    end

    it "returns false when items are present" do
      component = described_class.new(items: hash_items, columns: columns)
      expect(component.empty?).to be false
    end
  end

  describe "#column_count" do
    it "returns the number of columns" do
      component = described_class.new(items: hash_items, columns: columns)
      expect(component.column_count).to eq(3)
    end
  end

  describe "empty_message" do
    it "stores the empty message" do
      component = described_class.new(items: [], columns: columns, empty_message: "No products found.")
      expect(component.instance_variable_get(:@empty_message)).to eq("No products found.")
    end
  end
end
