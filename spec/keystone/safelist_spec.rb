# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Tailwind safelist" do
  # Constants that hold non-CSS values (e.g. HTML type maps)
  SKIP_CONSTANTS = %i[TYPE_MAP].freeze

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

  def all_constant_classes
    Keystone::Safelist::COMPONENTS.flat_map { |klass| extract_classes_from_constants(klass) }.uniq.sort
  end

  it "is auto-generated from component constants" do
    # Every class in a component frozen constant must appear in SAFELIST
    # without anyone manually editing safelist.rb
    missing = all_constant_classes - Keystone::SAFELIST.split

    expect(missing).to eq([]),
      "Classes in component constants but missing from SAFELIST:\n  #{missing.join("\n  ")}"
  end

  it "includes non-constant classes from ERB templates and methods" do
    Keystone::Safelist::NON_CONSTANT_CLASSES.each do |css_class|
      expect(Keystone::SAFELIST).to include(css_class),
        "NON_CONSTANT_CLASSES entry '#{css_class}' missing from SAFELIST"
    end
  end

  it "COMPONENTS lists every Keystone::Ui component" do
    # Finds all classes under Keystone::Ui that inherit ViewComponent::Base
    actual = Keystone::Ui.constants.filter_map { |c|
      klass = Keystone::Ui.const_get(c)
      klass if klass.is_a?(Class) && klass < ViewComponent::Base
    }.sort_by(&:name)

    listed = Keystone::Safelist::COMPONENTS.sort_by(&:name)

    expect(listed).to eq(actual),
      "Safelist::COMPONENTS is out of date. Missing: #{(actual - listed).map(&:name).join(', ')}"
  end
end
