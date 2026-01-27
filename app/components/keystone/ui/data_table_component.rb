# frozen_string_literal: true

module Keystone
  module Ui
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
        @actions_block = nil
      end

      def before_render
        content
      end

      def actions(&block)
        @actions_block = block
      end

      def actions?
        !!@actions_block
      end

      def column_keys
        @column_keys ||= @columns.map { |col| col.keys.reject { |k| k == :link }.first }
      end

      def column_labels
        @column_labels ||= @columns.map { |col| col.values.first }
      end

      def column_links
        @column_links ||= @columns.map { |col| col[:link] }
      end

      def header_cells
        cells = column_labels.map.with_index do |label, index|
          {
            label: label,
            classes: header_classes_for(index),
            scope: "col"
          }
        end

        if actions?
          cells << {
            label: "Actions",
            classes: HEADER_CLASSES_LAST,
            scope: "col"
          }
        end

        cells
      end

      def row_cells
        @row_cells ||= @items.map do |item|
          column_keys.map.with_index do |key, index|
            cell = {
              value: resolve_value(item, key),
              classes: row_classes_for(index)
            }

            link_proc = column_links[index]
            cell[:href] = link_proc.call(item) if link_proc

            cell
          end
        end
      end

      def empty?
        @items.empty?
      end

      def column_count
        visual_column_count
      end

      private

      def visual_column_count
        @columns.length + (actions? ? 1 : 0)
      end

      def resolve_value(item, key)
        if item.respond_to?(key)
          item.public_send(key)
        else
          item[key]
        end
      end

      def header_classes_for(index)
        last_data_index = @columns.length - 1

        return HEADER_CLASSES_FIRST if index.zero?
        return HEADER_CLASSES_LAST if index == last_data_index && !actions?

        HEADER_CLASSES_MIDDLE
      end

      def row_classes_for(index)
        last_data_index = @columns.length - 1

        return ROW_CLASSES_FIRST if index.zero?
        return ROW_CLASSES_LAST if index == last_data_index && !actions?

        ROW_CLASSES_MIDDLE
      end
    end
  end
end
