# frozen_string_literal: true

module KeystoneComponents
  class Engine < ::Rails::Engine
    config.autoload_paths << root.join("app/components")

    # Inject @source with the gem's component path into application.css
    # so Tailwind can scan component files during asset compilation.
    # Runs during app boot (before assets:precompile triggers tailwindcss:build).
    initializer "keystone_components.tailwind_source" do
      css_path = Rails.root.join("app/assets/tailwind/application.css")
      next unless css_path.exist?

      content = css_path.read
      marker = "/* keystone:source */"
      next unless content.include?(marker)

      source_line = "#{marker} @source \"#{root}/app/components/**/*.{erb,rb}\";"
      updated = content.sub(/#{Regexp.escape(marker)}.*$/, source_line)
      css_path.write(updated)
    end
  end
end
