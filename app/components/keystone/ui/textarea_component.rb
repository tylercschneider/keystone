# frozen_string_literal: true

module Keystone
  module Ui
    class TextareaComponent < ViewComponent::Base
      BASE_CLASSES = "block w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-sm text-gray-900 placeholder:text-gray-400 focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500 dark:bg-zinc-900 dark:border-zinc-700 dark:text-white dark:placeholder:text-gray-500 dark:focus:border-indigo-400 dark:focus:ring-indigo-400"

      DISABLED_CLASSES = "cursor-not-allowed bg-gray-50 text-gray-500 dark:bg-zinc-800 dark:text-gray-400"

      def initialize(name:, value: nil, rows: 3, placeholder: nil, disabled: false)
        @name = name
        @value = value
        @rows = rows
        @placeholder = placeholder
        @disabled = disabled
      end

      def classes
        tokens = [BASE_CLASSES]
        tokens << DISABLED_CLASSES if @disabled
        tokens.join(" ")
      end

      def tag_options
        options = {
          name: @name,
          rows: @rows,
          class: classes
        }
        options[:placeholder] = @placeholder unless @placeholder.nil?
        options[:disabled] = true if @disabled
        options
      end
    end
  end
end
