# frozen_string_literal: true

module Keystone
  module Ui
    class MobileActionsComponent < ViewComponent::Base
      ELLIPSIS_ICON = <<~SVG.freeze
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
          <path stroke-linecap="round" stroke-linejoin="round" d="M12 6.75a.75.75 0 1 1 0-1.5.75.75 0 0 1 0 1.5ZM12 12.75a.75.75 0 1 1 0-1.5.75.75 0 0 1 0 1.5ZM12 18.75a.75.75 0 1 1 0-1.5.75.75 0 0 1 0 1.5Z" />
        </svg>
      SVG

      BUTTON_CLASSES = "text-gray-500 dark:text-gray-400"
      DROPDOWN_CLASSES = "hidden absolute right-0 z-50 mt-2 w-48 origin-top-right rounded-md bg-white py-1 shadow-lg ring-1 ring-black/5 dark:bg-zinc-800 dark:ring-white/10"
    end
  end
end
