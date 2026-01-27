# frozen_string_literal: true

module Keystone
  module UI
    class DataTableComponent < ViewComponent::Base
      HEADER_CLASSES_FIRST = "py-3.5 pr-3 pl-4 text-left text-sm font-semibold text-gray-900 sm:pl-6 dark:text-gray-200"
      HEADER_CLASSES_MIDDLE = "px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-200"
      HEADER_CLASSES_LAST = "py-3.5 pr-4 pl-3 sm:pr-6"

      ROW_CLASSES_FIRST = "py-4 pr-3 pl-4 text-sm font-medium whitespace-nowrap text-gray-900 sm:pl-6 dark:text-white"
      ROW_CLASSES_MIDDLE = "px-3 py-4 text-sm whitespace-nowrap text-gray-500 dark:text-gray-400"
      ROW_CLASSES_LAST = "py-4 pr-4 pl-3 text-right text-sm font-medium whitespace-nowrap sm:pr-6"

      def initialize(items:, columns:, empty_message: nil)
        @items = items
        @columns = columns
        @empty_message = empty_message
      end

      def column_keys
        @column_keys ||= @columns.map { |col| col.keys.first }
      end

      def column_labels
        @column_labels ||= @columns.map { |col| col.values.first }
      end

      def header_cells
        @header_cells ||= column_labels.map.with_index do |label, index|
          {
            label: label,
            classes: header_classes_for(index),
            scope: "col"
          }
        end
      end

      def row_cells
        @row_cells ||= @items.map do |item|
          column_keys.map.with_index do |key, index|
            {
              value: resolve_value(item, key),
              classes: row_classes_for(index)
            }
          end
        end
      end

      def empty?
        @items.empty?
      end

      def column_count
        @columns.length
      end

      private

      def resolve_value(item, key)
        if item.respond_to?(key)
          item.public_send(key)
        else
          item[key]
        end
      end

      def header_classes_for(index)
        return HEADER_CLASSES_FIRST if index.zero?
        return HEADER_CLASSES_LAST if index == @columns.length - 1

        HEADER_CLASSES_MIDDLE
      end

      def row_classes_for(index)
        return ROW_CLASSES_FIRST if index.zero?
        return ROW_CLASSES_LAST if index == @columns.length - 1

        ROW_CLASSES_MIDDLE
      end
    end
  end
end
