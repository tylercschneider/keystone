# frozen_string_literal: true

module Keystone
  module Ui
    class PanelComponent < ViewComponent::Base
      PADDING_CLASSES = { sm: "p-4", md: "p-5", lg: "p-6" }.freeze
      RADIUS_CLASSES = { md: "rounded-lg", lg: "rounded-xl", xl: "rounded-2xl" }.freeze

      def initialize(padding: :md, radius: :lg, shadow: true)
        @padding = padding
        @radius = radius
        @shadow = shadow
      end

      def classes
        tokens = [
          RADIUS_CLASSES.fetch(@radius),
          "border border-gray-200",
          "bg-white",
          PADDING_CLASSES.fetch(@padding),
          "dark:bg-zinc-900 dark:border-zinc-700"
        ]
        tokens << "shadow-sm" if @shadow
        tokens.join(" ")
      end
    end
  end
end
