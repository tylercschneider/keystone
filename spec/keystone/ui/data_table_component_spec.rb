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

  describe "actions" do
    it "returns false for actions? when no block is set" do
      component = described_class.new(items: hash_items, columns: columns)
      expect(component.actions?).to be false
    end

    it "returns true for actions? after calling actions with a block" do
      component = described_class.new(items: hash_items, columns: columns)
      component.actions { |item| "Edit #{item[:name]}" }
      expect(component.actions?).to be true
    end

    it "before_render evaluates the content block so actions are registered" do
      component = described_class.new(items: hash_items, columns: columns)
      component.set_content_block do |table|
        table.actions { |item| "Edit #{item[:name]}" }
      end

      expect(component.actions?).to be false
      component.before_render
      expect(component.actions?).to be true
    end

    it "appends an Actions header with LAST classes" do
      component = described_class.new(items: hash_items, columns: columns)
      component.actions { |item| "Edit" }

      headers = component.header_cells
      expect(headers.last).to eq({
        label: "Actions",
        classes: described_class::HEADER_CLASSES_LAST,
        scope: "col"
      })
    end

    it "shifts the last data column from LAST to MIDDLE when actions are present" do
      component = described_class.new(items: hash_items, columns: columns)
      component.actions { |item| "Edit" }

      headers = component.header_cells
      # "Price" was the last data column — should now be MIDDLE
      price_header = headers.find { |h| h[:label] == "Price" }
      expect(price_header[:classes]).to eq(described_class::HEADER_CLASSES_MIDDLE)
    end

    it "shifts row classes so last data column becomes MIDDLE" do
      component = described_class.new(items: [hash_items.first], columns: columns)
      component.actions { |item| "Edit" }

      row = component.row_cells.first
      expect(row[0][:classes]).to eq(described_class::ROW_CLASSES_FIRST)
      expect(row[1][:classes]).to eq(described_class::ROW_CLASSES_MIDDLE)
      expect(row[2][:classes]).to eq(described_class::ROW_CLASSES_MIDDLE)
    end

    it "includes the actions column in column_count" do
      component = described_class.new(items: hash_items, columns: columns)
      component.actions { |item| "Edit" }
      expect(component.column_count).to eq(4)
    end
  end

  describe "linkable cells" do
    let(:link_columns) do
      [
        { name: "Name", link: ->(item) { "/projects/#{item[:name].downcase}" } },
        { quantity: "Quantity" },
        { price: "Price" }
      ]
    end

    it "includes :href in cell hash when column has a :link proc" do
      component = described_class.new(items: hash_items, columns: link_columns)
      row = component.row_cells.first

      expect(row[0][:href]).to eq("/projects/apples")
    end

    it "omits :href when column has no :link" do
      component = described_class.new(items: hash_items, columns: link_columns)
      row = component.row_cells.first

      expect(row[1]).not_to have_key(:href)
      expect(row[2]).not_to have_key(:href)
    end

    it "resolves link per item" do
      component = described_class.new(items: hash_items, columns: link_columns)

      expect(component.row_cells[0][0][:href]).to eq("/projects/apples")
      expect(component.row_cells[1][0][:href]).to eq("/projects/bananas")
    end

    it "extracts column keys correctly when :link is present" do
      component = described_class.new(items: hash_items, columns: link_columns)
      expect(component.column_keys).to eq([:name, :quantity, :price])
    end

    it "extracts column labels correctly when :link is present" do
      component = described_class.new(items: hash_items, columns: link_columns)
      expect(component.column_labels).to eq(["Name", "Quantity", "Price"])
    end
  end

  describe "combined actions and linkable cells" do
    let(:link_columns) do
      [
        { name: "Name", link: ->(item) { "/projects/#{item[:name].downcase}" } },
        { quantity: "Quantity" },
        { price: "Price" }
      ]
    end

    it "applies correct position classes with both features" do
      component = described_class.new(items: [hash_items.first], columns: link_columns)
      component.actions { |item| "Edit" }

      headers = component.header_cells
      expect(headers[0][:classes]).to eq(described_class::HEADER_CLASSES_FIRST)
      expect(headers[1][:classes]).to eq(described_class::HEADER_CLASSES_MIDDLE)
      expect(headers[2][:classes]).to eq(described_class::HEADER_CLASSES_MIDDLE)
      expect(headers[3][:classes]).to eq(described_class::HEADER_CLASSES_LAST)
      expect(headers[3][:label]).to eq("Actions")

      row = component.row_cells.first
      expect(row[0][:href]).to eq("/projects/apples")
      expect(row[0][:classes]).to eq(described_class::ROW_CLASSES_FIRST)
      expect(row[1][:classes]).to eq(described_class::ROW_CLASSES_MIDDLE)
      expect(row[2][:classes]).to eq(described_class::ROW_CLASSES_MIDDLE)
    end

    it "includes actions in column_count with linkable columns" do
      component = described_class.new(items: hash_items, columns: link_columns)
      component.actions { |item| "Edit" }
      expect(component.column_count).to eq(4)
    end
  end
end
