# frozen_string_literal: true

module Keystone
  module Ui
    class ButtonComponent < ViewComponent::Base
      BASE_CLASSES = "inline-flex items-center justify-center font-semibold rounded-lg border-0 cursor-pointer no-underline"

      VARIANT_CLASSES = {
        primary: "bg-indigo-600 text-white hover:bg-indigo-500",
        secondary: "bg-gray-500 text-white hover:bg-gray-400",
        danger: "bg-red-600 text-white hover:bg-red-500"
      }.freeze

      SIZE_CLASSES = {
        sm: "text-sm px-3 py-1.5",
        md: "text-base px-4 py-2",
        lg: "text-lg px-5 py-3"
      }.freeze

      def initialize(label:, href: nil, variant: :primary, size: :md)
        @label = label
        @href = href
        @variant = variant
        @size = size
      end

      def classes
        [BASE_CLASSES, VARIANT_CLASSES.fetch(@variant), SIZE_CLASSES.fetch(@size)].join(" ")
      end

      def tag_name
        button? ? :button : :a
      end

      def tag_options
        options = { class: classes }
        if button?
          options[:type] = "button"
        else
          options[:href] = @href
        end
        options
      end

      def button?
        @href.nil?
      end
    end
  end
end
