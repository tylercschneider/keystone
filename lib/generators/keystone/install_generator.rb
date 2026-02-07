# frozen_string_literal: true

module Keystone
  class InstallGenerator < Rails::Generators::Base
    desc "Set up Keystone Components in your Rails application"

    IMPORT_LINE = '@import "../builds/tailwind/keystone_components_engine";'

    def setup_instructions
      say ""
      say "Keystone Components — setup", :green
      say "=" * 40
      say ""
      say "Prerequisites:"
      say "  1. tailwindcss-rails v4+ must be installed"
      say "     → rails generate tailwindcss:install"
      say ""
      say "  2. Add this import to your app/assets/tailwind/application.css:"
      say "     #{IMPORT_LINE}"
      say ""

      css_path = Rails.root.join("app/assets/tailwind/application.css")
      if css_path.exist?
        content = css_path.read
        if content.include?(IMPORT_LINE)
          say "  ✔ Import already present in application.css", :green
        else
          inject_into_file css_path, "#{IMPORT_LINE}\n", after: /@import\s+"tailwindcss";\n/
          say "  ✔ Import added to application.css", :green
        end
      else
        say "  ⚠ application.css not found at expected path.", :yellow
        say "    Run `rails generate tailwindcss:install` first."
      end

      say ""
      say "Done! See the README for component usage.", :green
    end

    def generate_claude_docs
      say ""
      say "Generating CLAUDE.md API reference...", :green
      rake "keystone:claude"
    end
  end
end
