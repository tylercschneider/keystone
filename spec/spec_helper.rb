# frozen_string_literal: true

unless defined?(ViewComponent)
  module ViewComponent
    class Base
      def content
        @__content_block&.call(self)
      end

      def set_content_block(&block)
        @__content_block = block
      end
    end
  end
end

require_relative "../app/components/keystone/ui/button_component"
require_relative "../app/components/keystone/ui/data_table_component"
