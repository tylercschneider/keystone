# frozen_string_literal: true

module Keystone
  module Ui
    class MobileHeaderComponent < ViewComponent::Base
      BACK_ICON = <<~SVG.freeze
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
          <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5 8.25 12l7.5-7.5" />
        </svg>
      SVG

      ELLIPSIS_ICON = <<~SVG.freeze
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
          <path stroke-linecap="round" stroke-linejoin="round" d="M12 6.75a.75.75 0 1 1 0-1.5.75.75 0 0 1 0 1.5ZM12 12.75a.75.75 0 1 1 0-1.5.75.75 0 0 1 0 1.5ZM12 18.75a.75.75 0 1 1 0-1.5.75.75 0 0 1 0 1.5Z" />
        </svg>
      SVG

      BACK_LINK_CLASSES = "text-gray-500 dark:text-gray-400"
      TITLE_CLASSES = "absolute left-1/2 -translate-x-1/2 font-semibold text-gray-900 dark:text-white lg:hidden truncate max-w-[60%]"
      DROPDOWN_CLASSES = "hidden absolute right-0 z-50 mt-2 w-48 origin-top-right rounded-md bg-white py-1 shadow-lg ring-1 ring-black/5 dark:bg-zinc-800 dark:ring-white/10"

      # Renders the left-side and title of the mobile header.
      # Call from the left side of your navbar.
      #
      # Usage in navbar:
      #   <% if content_for?(:form_page) %>
      #     <%= ui_mobile_header_left %>
      #   <% end %>
      def initialize(title:, back_url:)
        @title = title
        @back_url = back_url
      end
    end
  end
end
