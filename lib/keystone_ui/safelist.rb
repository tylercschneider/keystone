# frozen_string_literal: true

module Keystone
  module Safelist
    # All component classes to scan for Tailwind CSS classes.
    # The safelist_spec verifies this list matches Keystone::Ui components.
    COMPONENTS = [
      Keystone::Ui::CardComponent,
      Keystone::Ui::ButtonComponent,
      Keystone::Ui::DataTableComponent,
      Keystone::Ui::PageComponent,
      Keystone::Ui::SectionComponent,
      Keystone::Ui::GridComponent,
      Keystone::Ui::PanelComponent,
      Keystone::Ui::CardLinkComponent,
      Keystone::Ui::InputComponent,
      Keystone::Ui::TextareaComponent,
      Keystone::Ui::FormFieldComponent,
      Keystone::Ui::PageHeaderComponent,
      Keystone::Ui::AlertComponent
    ].freeze

    # Constants that hold non-CSS values (e.g. HTML input type maps)
    SKIP_CONSTANTS = %i[TYPE_MAP].freeze

    # Classes used in Ruby methods or ERB templates, not in frozen constants.
    # These cannot be auto-extracted and must be listed manually.
    # The safelist_spec ensures every entry here appears in SAFELIST.
    NON_CONSTANT_CLASSES = %w[
      grid
      mx-auto
      overflow-hidden rounded-lg border border-gray-200 shadow-sm
      dark:border-zinc-700 dark:shadow-none
      relative min-w-full divide-y divide-gray-300 dark:divide-white/15
      bg-gray-50 dark:bg-gray-800/75
      divide-gray-200 bg-white dark:divide-white/10 dark:bg-gray-800/50
      px-3 py-4 text-sm text-gray-500 dark:text-gray-400
      flex items-center justify-between mb-4
      text-lg font-semibold text-gray-900 dark:text-white
      mt-1 text-indigo-600 hover:text-indigo-900
      dark:text-indigo-400 dark:hover:text-indigo-300
      flex-1
      hover:border-indigo-500
    ].freeze

    def self.extract_classes_from_hash(hash, classes)
      hash.each_value do |v|
        case v
        when String then classes.concat(v.split)
        when Hash then extract_classes_from_hash(v, classes)
        end
      end
    end

    def self.generate
      classes = []

      COMPONENTS.each do |klass|
        klass.constants(false).each do |const_name|
          next if SKIP_CONSTANTS.include?(const_name)

          value = klass.const_get(const_name)
          case value
          when String then classes.concat(value.split)
          when Hash then extract_classes_from_hash(value, classes)
          end
        end
      end

      classes.concat(NON_CONSTANT_CLASSES)
      classes.uniq.sort.join(" ")
    end
  end

  SAFELIST = Safelist.generate
end
