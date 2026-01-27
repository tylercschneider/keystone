# frozen_string_literal: true

module Keystone
  module Ui
    class Column
      attr_reader :key, :header_text

      def initialize(key, header_text, mobile_hidden: false)
        @key = key
        @header_text = header_text
        @mobile_hidden = mobile_hidden
      end

      def mobile_hidden? = @mobile_hidden
    end
  end
end
