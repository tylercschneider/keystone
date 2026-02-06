# frozen_string_literal: true

module Keystone
  module Ui
    class CardLinkComponent < ViewComponent::Base
      PADDING_CLASSES = { sm: "p-3", md: "p-4", lg: "p-6" }.freeze

      attr_reader :href

      def initialize(href:, padding: :md, shadow: true)
        @href = href
        @padding = padding
        @shadow = shadow
      end

      def classes
        tokens = [
          "block",
          "rounded-lg",
          "border border-gray-200",
          "bg-white",
          PADDING_CLASSES.fetch(@padding),
          "hover:border-indigo-500",
          "dark:border-zinc-700 dark:bg-zinc-900"
        ]
        tokens << "shadow-sm" if @shadow
        tokens.join(" ")
      end
    end
  end
end
