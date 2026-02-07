# frozen_string_literal: true

require_relative "lib/keystone_components/version"

Gem::Specification.new do |spec|
  spec.name = "keystone_components"
  spec.version = KeystoneComponents::VERSION
  spec.authors = ["Keystone"]
  spec.email = ["dev@example.com"]

  spec.summary = "Reusable UI component system for Rails applications."
  spec.description = "Reusable UI component system for Rails applications using ViewComponent."
  spec.homepage = "https://github.com/tylercschneider/keystone"
  spec.license = "MIT"

  spec.metadata["source_code_uri"] = "https://github.com/tylercschneider/keystone"

  spec.required_ruby_version = ">= 3.0.0"

  spec.files = Dir["lib/**/*", "app/**/*"]
  spec.require_paths = ["lib"]

  spec.add_dependency "view_component", ">= 2.0"

  spec.post_install_message = <<~MSG
    Keystone Components installed!

    Prerequisites: tailwindcss-rails v4+

    Run the install generator for setup instructions:
      rails generate keystone:install
  MSG
end
