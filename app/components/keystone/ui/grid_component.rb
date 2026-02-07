# frozen_string_literal: true

module Keystone
  module Ui
    class GridComponent < ViewComponent::Base
      GAP_CLASSES = { sm: "gap-3", md: "gap-4", lg: "gap-6", xl: "gap-8" }.freeze
      GAP_X_CLASSES = { sm: "gap-x-3", md: "gap-x-4", lg: "gap-x-6", xl: "gap-x-8" }.freeze
      GAP_Y_CLASSES = { sm: "gap-y-3", md: "gap-y-4", lg: "gap-y-6", xl: "gap-y-8" }.freeze
      COL_CLASSES = {
        default: { 1 => "grid-cols-1", 2 => "grid-cols-2", 3 => "grid-cols-3", 4 => "grid-cols-4", 5 => "grid-cols-5", 6 => "grid-cols-6", 7 => "grid-cols-7", 8 => "grid-cols-8", 9 => "grid-cols-9", 10 => "grid-cols-10", 11 => "grid-cols-11", 12 => "grid-cols-12" }.freeze,
        sm: { 1 => "sm:grid-cols-1", 2 => "sm:grid-cols-2", 3 => "sm:grid-cols-3", 4 => "sm:grid-cols-4", 5 => "sm:grid-cols-5", 6 => "sm:grid-cols-6", 7 => "sm:grid-cols-7", 8 => "sm:grid-cols-8", 9 => "sm:grid-cols-9", 10 => "sm:grid-cols-10", 11 => "sm:grid-cols-11", 12 => "sm:grid-cols-12" }.freeze,
        md: { 1 => "md:grid-cols-1", 2 => "md:grid-cols-2", 3 => "md:grid-cols-3", 4 => "md:grid-cols-4", 5 => "md:grid-cols-5", 6 => "md:grid-cols-6", 7 => "md:grid-cols-7", 8 => "md:grid-cols-8", 9 => "md:grid-cols-9", 10 => "md:grid-cols-10", 11 => "md:grid-cols-11", 12 => "md:grid-cols-12" }.freeze,
        lg: { 1 => "lg:grid-cols-1", 2 => "lg:grid-cols-2", 3 => "lg:grid-cols-3", 4 => "lg:grid-cols-4", 5 => "lg:grid-cols-5", 6 => "lg:grid-cols-6", 7 => "lg:grid-cols-7", 8 => "lg:grid-cols-8", 9 => "lg:grid-cols-9", 10 => "lg:grid-cols-10", 11 => "lg:grid-cols-11", 12 => "lg:grid-cols-12" }.freeze
      }.freeze

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
          tokens << COL_CLASSES.fetch(breakpoint).fetch(count)
        end
        tokens.join(" ")
      end
    end
  end
end
