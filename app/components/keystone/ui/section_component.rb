# frozen_string_literal: true

module Keystone
  module Ui
    class SectionComponent < ViewComponent::Base
      SPACING_CLASSES = { sm: "mt-4", md: "mt-6", lg: "mt-8" }.freeze

      def initialize(title: nil, subtitle: nil, action: nil, spacing: :md)
        @title = title
        @subtitle = subtitle
        @action = action
        @spacing = spacing
      end

      def spacing_class
        SPACING_CLASSES.fetch(@spacing)
      end

      def header?
        !@title.nil?
      end
    end
  end
end
