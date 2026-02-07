# frozen_string_literal: true

module Keystone
  module Ui
    class FormFieldComponent < ViewComponent::Base
      WRAPPER_CLASSES = "space-y-1"
      LABEL_CLASSES = "block text-sm font-medium text-gray-700 dark:text-gray-300"
      REQUIRED_CLASSES = "text-red-500 ml-0.5"
      HINT_CLASSES = "mt-1 text-sm text-gray-500 dark:text-gray-400"
      ERROR_CLASSES = "mt-1 text-sm text-red-600 dark:text-red-400"

      def initialize(attribute:, label: nil, type: :text, required: false, hint: nil, placeholder: nil, min: nil, max: nil)
        @attribute = attribute
        @label = label
        @type = type
        @required = required
        @hint = hint
        @placeholder = placeholder
        @min = min
        @max = max
      end

      def label_text
        @label || @attribute.to_s.tr("_", " ").capitalize
      end

      def required?
        @required
      end

      def hint?
        !@hint.nil?
      end

      def hint_text
        @hint
      end

      def textarea?
        @type == :textarea
      end

      def input_options
        options = { name: @attribute.to_s }
        unless textarea?
          options[:type] = Keystone::Ui::InputComponent::TYPE_MAP.fetch(@type)
        end
        options[:placeholder] = @placeholder unless @placeholder.nil?
        options[:min] = @min unless @min.nil?
        options[:max] = @max unless @max.nil?
        options
      end
    end
  end
end
