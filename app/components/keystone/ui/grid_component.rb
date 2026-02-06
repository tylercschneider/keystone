# frozen_string_literal: true

module Keystone
  module Ui
    class GridComponent < ViewComponent::Base
      GAP_CLASSES = { sm: "gap-3", md: "gap-4", lg: "gap-6" }.freeze
      COL_PREFIX = { default: "grid-cols", sm: "sm:grid-cols", md: "md:grid-cols", lg: "lg:grid-cols" }.freeze

      def initialize(cols: { default: 1 }, gap: :md)
        @cols = cols
        @gap = gap
      end

      def classes
        tokens = ["grid", GAP_CLASSES.fetch(@gap)]
        @cols.each do |breakpoint, count|
          prefix = COL_PREFIX.fetch(breakpoint)
          tokens << "#{prefix}-#{count}"
        end
        tokens.join(" ")
      end
    end
  end
end
