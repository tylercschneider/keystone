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

require_relative "../app/components/keystone/ui/card_component"
require_relative "../app/components/keystone/ui/button_component"
require_relative "../app/components/keystone/ui/data_table_component"
require_relative "../app/components/keystone/ui/page_component"
require_relative "../app/components/keystone/ui/section_component"
require_relative "../app/components/keystone/ui/grid_component"
require_relative "../app/components/keystone/ui/panel_component"
require_relative "../app/components/keystone/ui/card_link_component"
require_relative "../app/components/keystone/ui/input_component"
require_relative "../app/components/keystone/ui/textarea_component"
require_relative "../app/components/keystone/ui/form_field_component"
require_relative "../app/components/keystone/ui/page_header_component"
