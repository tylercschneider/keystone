# frozen_string_literal: true

module Keystone
  module Ui
    class PageHeaderComponent < ViewComponent::Base
      WRAPPER_CLASSES = "mb-6 sm:flex sm:items-center sm:justify-between"
      TITLE_CLASSES = "text-2xl font-bold text-gray-900 dark:text-white"
      SUBTITLE_CLASSES = "mt-1 text-sm text-gray-500 dark:text-gray-400"
      ACTIONS_CLASSES = "mt-4 sm:mt-0 sm:ml-4 flex-shrink-0"

      attr_reader :title

      def initialize(title:, subtitle: nil)
        @title = title
        @subtitle = subtitle
        @action_block = nil
      end

      def before_render
        content
      end

      def action(&block)
        @action_block = block
      end

      def action?
        !!@action_block
      end

      def subtitle?
        !@subtitle.nil?
      end

      def subtitle_text
        @subtitle
      end
    end
  end
end
