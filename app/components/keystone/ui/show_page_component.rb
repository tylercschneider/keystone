# frozen_string_literal: true

module Keystone
  module Ui
    class ShowPageComponent < ViewComponent::Base
      def initialize(title:, back_url:)
        @title = title
        @back_url = back_url
      end
    end
  end
end
