# frozen_string_literal: true

module Keystone
  module Ui
    class Column
      attr_reader :key, :header_text

      def initialize(key, header_text)
        @key = key
        @header_text = header_text
      end
    end
  end
end
