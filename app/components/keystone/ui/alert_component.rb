# frozen_string_literal: true

module Keystone
  module Ui
    class AlertComponent < ViewComponent::Base
      BASE_CLASSES = "rounded-md p-4"

      TYPE_CLASSES = {
        info: "bg-blue-50 text-blue-800 dark:bg-blue-900/30 dark:text-blue-300",
        success: "bg-green-50 text-green-800 dark:bg-green-900/30 dark:text-green-300",
        warning: "bg-yellow-50 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-300",
        error: "bg-red-50 text-red-800 dark:bg-red-900/30 dark:text-red-300"
      }.freeze

      TITLE_CLASSES = "font-semibold"
      MESSAGE_CLASSES = "text-sm"
      DISMISS_CLASSES = "ml-auto -mr-1.5 -mt-1.5 inline-flex rounded-md p-1.5 focus:outline-none focus:ring-2 focus:ring-offset-2 cursor-pointer"

      def initialize(message:, type: :info, title: nil, dismissible: false)
        @message = message
        @type = type
        @title = title
        @dismissible = dismissible
      end

      def classes
        [BASE_CLASSES, TYPE_CLASSES.fetch(@type)].join(" ")
      end

      def message_text
        @message
      end

      def title?
        !@title.nil?
      end

      def title_text
        @title
      end

      def dismissible?
        @dismissible
      end
    end
  end
end
