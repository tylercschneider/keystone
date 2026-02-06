# frozen_string_literal: true

module Keystone
  module Ui
    class PageComponent < ViewComponent::Base
      MAX_WIDTH_CLASSES = {
        sm: "max-w-2xl",
        md: "max-w-4xl",
        lg: "max-w-6xl",
        xl: "max-w-7xl",
        full: ""
      }.freeze

      PADDING_CLASSES = "px-4 sm:px-6 lg:px-8"

      def initialize(max_width: :full, padding: :standard)
        @max_width = max_width
        @padding = padding
      end

      def classes
        tokens = []
        tokens << PADDING_CLASSES unless @padding == :none
        width_class = MAX_WIDTH_CLASSES.fetch(@max_width)
        tokens << width_class unless width_class.empty?
        tokens << "mx-auto" unless @max_width == :full
        tokens.join(" ")
      end
    end
  end
end
