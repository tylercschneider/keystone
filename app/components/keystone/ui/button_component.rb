# frozen_string_literal: true

module Keystone
  module Ui
    class ButtonComponent < ViewComponent::Base
      VARIANT_CLASSES = {
        primary: "ui-button--primary",
        secondary: "ui-button--secondary",
        danger: "ui-button--danger"
      }.freeze

      SIZE_CLASSES = {
        sm: "ui-button--sm",
        md: "ui-button--md",
        lg: "ui-button--lg"
      }.freeze

      def initialize(label:, href: nil, variant: :primary, size: :md)
        @label = label
        @href = href
        @variant = variant
        @size = size
      end

      def classes
        ["ui-button", VARIANT_CLASSES.fetch(@variant), SIZE_CLASSES.fetch(@size)].join(" ")
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
