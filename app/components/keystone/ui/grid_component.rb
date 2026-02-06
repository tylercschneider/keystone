# frozen_string_literal: true

module Keystone
  module Ui
    class GridComponent < ViewComponent::Base
      GAP_CLASSES = { sm: "gap-3", md: "gap-4", lg: "gap-6", xl: "gap-8" }.freeze
      GAP_X_CLASSES = { sm: "gap-x-3", md: "gap-x-4", lg: "gap-x-6", xl: "gap-x-8" }.freeze
      GAP_Y_CLASSES = { sm: "gap-y-3", md: "gap-y-4", lg: "gap-y-6", xl: "gap-y-8" }.freeze
      COL_PREFIX = { default: "grid-cols", sm: "sm:grid-cols", md: "md:grid-cols", lg: "lg:grid-cols" }.freeze

      def initialize(cols: { default: 1 }, gap: :md, gap_x: nil, gap_y: nil)
        @cols = cols
        @gap = gap
        @gap_x = gap_x
        @gap_y = gap_y
      end

      def classes
        tokens = ["grid"]
        if @gap_x || @gap_y
          tokens << GAP_X_CLASSES.fetch(@gap_x) if @gap_x
          tokens << GAP_Y_CLASSES.fetch(@gap_y) if @gap_y
        else
          tokens << GAP_CLASSES.fetch(@gap)
        end
        @cols.each do |breakpoint, count|
          prefix = COL_PREFIX.fetch(breakpoint)
          tokens << "#{prefix}-#{count}"
        end
        tokens.join(" ")
      end
    end
  end
end
