# frozen_string_literal: true

module Keystone
  module Ui
    class FormPageComponent < ViewComponent::Base
      TITLE_CLASSES = "text-2xl font-semibold text-gray-900 dark:text-white"
      SUBTITLE_CLASSES = "mt-1 text-sm text-gray-500 dark:text-gray-400"

      def initialize(title:, back_url:, subtitle: nil)
        @title = title
        @back_url = back_url
        @subtitle = subtitle
      end

      def subtitle?
        !@subtitle.nil?
      end
    end
  end
end
