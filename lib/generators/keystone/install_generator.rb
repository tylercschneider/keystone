# frozen_string_literal: true

module Keystone
  class InstallGenerator < Rails::Generators::Base
    desc "Set up Keystone Components in your Rails application"

    TAILWIND_IMPORT = '@import "tailwindcss";'
    SOURCE_MARKER = "/* keystone:source */"

    def setup_tailwind
      say ""
      say "Keystone Components — setup", :green
      say "=" * 40
      say ""

      css_path = Rails.root.join("app/assets/tailwind/application.css")
      unless css_path.exist?
        say "  ⚠ application.css not found.", :yellow
        say "    Run `rails generate tailwindcss:install` first."
        say ""
        return
      end

      content = css_path.read

      # Inject marker comment (path is resolved at build time by keystone:inject_source)
      unless content.include?(SOURCE_MARKER)
        inject_into_file css_path, "#{SOURCE_MARKER}\n", after: /#{Regexp.escape(TAILWIND_IMPORT)}\n/
        say "  ✔ Added Keystone source marker", :green
      else
        say "  ✔ Keystone source marker present", :green
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
