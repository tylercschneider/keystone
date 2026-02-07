# frozen_string_literal: true

module Keystone
  module Ui
    class CardComponent < ViewComponent::Base
      CARD_CLASSES = "overflow-hidden rounded-lg border border-gray-200 bg-white dark:bg-zinc-900 dark:border-zinc-700"
      CARD_EDGE_CLASSES = "overflow-hidden border-y border-gray-200 bg-white sm:rounded-lg sm:border-x dark:bg-zinc-900 dark:border-zinc-700"
      BODY_CLASSES = "px-4 py-4 sm:px-6 sm:pt-6 sm:pb-4"
      CTA_CLASSES = "px-4 pb-4 sm:px-6 sm:pb-6"
      TITLE_CLASSES = "text-lg font-semibold text-gray-900 dark:text-white m-0"
      SUMMARY_CLASSES = "mt-1 text-sm text-gray-500 dark:text-gray-400 mb-0"
      LINK_CLASSES = "text-sm font-medium text-indigo-600 hover:text-indigo-900 dark:text-indigo-400 no-underline"

      def initialize(title:, summary:, link:, cta: "Read more", edge_to_edge: false)
        @title = title
        @summary = summary
        @link = link
        @cta = cta
        @edge_to_edge = edge_to_edge
      end

      private

      def card_classes
        @edge_to_edge ? CARD_EDGE_CLASSES : CARD_CLASSES
      end
    end
  end
end
