# frozen_string_literal: true

module Keystone
  module Ui
    class InputComponent < ViewComponent::Base
      BASE_CLASSES = "block w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-sm text-gray-900 placeholder:text-gray-400 focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500 dark:bg-zinc-900 dark:border-zinc-700 dark:text-white dark:placeholder:text-gray-500 dark:focus:border-indigo-400 dark:focus:ring-indigo-400"

      DISABLED_CLASSES = "cursor-not-allowed bg-gray-50 text-gray-500 dark:bg-zinc-800 dark:text-gray-400"

      TYPE_MAP = {
        text: "text",
        number: "number",
        email: "email",
        password: "password"
      }.freeze

      def initialize(name:, type: :text, value: nil, placeholder: nil, disabled: false, min: nil, max: nil, step: nil)
        @name = name
        @type = type
        @value = value
        @placeholder = placeholder
        @disabled = disabled
        @min = min
        @max = max
        @step = step
      end

      def classes
        tokens = [BASE_CLASSES]
        tokens << DISABLED_CLASSES if @disabled
        tokens.join(" ")
      end

      def input_type
        TYPE_MAP.fetch(@type)
      end

      def tag_options
        options = {
          type: input_type,
          name: @name,
          class: classes
        }
        options[:value] = @value unless @value.nil?
        options[:placeholder] = @placeholder unless @placeholder.nil?
        options[:disabled] = true if @disabled
        options[:min] = @min unless @min.nil?
        options[:max] = @max unless @max.nil?
        options[:step] = @step unless @step.nil?
        options
      end
    end
  end
end
