# frozen_string_literal: true

module Keystone
  module UI
    class CardComponent < ViewComponent::Base
      def initialize(title:, summary:, link:, cta: "Read more")
        @title = title
        @summary = summary
        @link = link
        @cta = cta
      end
    end
  end
end
