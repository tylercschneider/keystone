# frozen_string_literal: true

module Keystone
  module UI
    class TableComponent < ViewComponent::Base
      HEADER_CLASSES_FIRST = "py-3.5 pr-3 pl-4 text-left text-sm font-semibold text-gray-900 sm:pl-6 dark:text-gray-200"
      HEADER_CLASSES_MIDDLE = "px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-200"
      HEADER_CLASSES_LAST = "py-3.5 pr-4 pl-3 sm:pr-6"

      ROW_CLASSES_FIRST = "py-4 pr-3 pl-4 text-sm font-medium whitespace-nowrap text-gray-900 sm:pl-6 dark:text-white"
      ROW_CLASSES_MIDDLE = "px-3 py-4 text-sm whitespace-nowrap text-gray-500 dark:text-gray-400"
      ROW_CLASSES_LAST = "py-4 pr-4 pl-3 text-right text-sm font-medium whitespace-nowrap sm:pr-6"

      def initialize(headers:, rows:, empty_message: nil)
        @headers = headers
        @rows = rows
        @empty_message = empty_message
      end

      def header_cells
        @header_cells ||= normalize_headers
      end

      def row_cells
        @row_cells ||= normalize_rows
      end

      def empty?
        @rows.empty?
      end

      def column_count
        @headers.length
      end

      private

      def normalize_headers
        @headers.map.with_index do |header, index|
          data = header.is_a?(Hash) ? header : { label: header }
          {
            label: data.fetch(:label),
            sr_only: data.fetch(:sr_only, false),
            classes: data[:classes] || header_classes_for(index),
            scope: data.fetch(:scope, "col")
          }
        end
      end

      def normalize_rows
        @rows.map do |row|
          row_data = row.is_a?(Hash) ? row.fetch(:cells) : row
          row_data.map.with_index do |cell, index|
            data = cell.is_a?(Hash) ? cell : { content: cell }
            {
              content: data.fetch(:content),
              classes: data[:classes] || row_classes_for(index, row_data.length),
              tag: data.fetch(:tag, "td")
            }
          end
        end
      end

      def header_classes_for(index)
        return HEADER_CLASSES_FIRST if index.zero?
        return HEADER_CLASSES_LAST if index == @headers.length - 1

        HEADER_CLASSES_MIDDLE
      end

      def row_classes_for(index, row_length)
        return ROW_CLASSES_FIRST if index.zero?
        return ROW_CLASSES_LAST if index == row_length - 1

        ROW_CLASSES_MIDDLE
      end
    end
  end
end
