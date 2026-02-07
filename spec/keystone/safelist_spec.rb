# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Tailwind safelist" do
  # All component classes that define Tailwind CSS class constants
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

  # Constants that hold non-CSS values (e.g. HTML type maps)
  SKIP_CONSTANTS = %i[TYPE_MAP].freeze

  # Classes used in Ruby methods or ERB templates, not in frozen constants
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

  def extract_classes_from_constants(klass)
    classes = []
    klass.constants(false).each do |const_name|
      next if SKIP_CONSTANTS.include?(const_name)

      value = klass.const_get(const_name)
      case value
      when String
        classes.concat(value.split)
      when Hash
        extract_classes_from_hash(value, classes)
      end
    end
    classes.uniq
  end

  def extract_classes_from_hash(hash, classes)
    hash.each_value do |v|
      case v
      when String then classes.concat(v.split)
      when Hash then extract_classes_from_hash(v, classes)
      end
    end
  end

  def all_component_classes
    classes = COMPONENTS.flat_map { |klass| extract_classes_from_constants(klass) }
    classes.concat(NON_CONSTANT_CLASSES)
    classes.uniq.sort
  end

  def safelist_classes
    Keystone::SAFELIST.split
  end

  it "Keystone::SAFELIST includes every class used by components" do
    missing = all_component_classes - safelist_classes

    expect(missing).to eq([]),
      "Missing from safelist:\n  #{missing.join("\n  ")}"
  end

  it "Keystone::SAFELIST does not include classes no component uses" do
    extra = safelist_classes - all_component_classes

    expect(extra).to eq([]),
      "Extra classes in safelist (not used by any component):\n  #{extra.join("\n  ")}"
  end
end
