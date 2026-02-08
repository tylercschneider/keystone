# frozen_string_literal: true

module Keystone
  class InstallGenerator < Rails::Generators::Base
    desc "Set up Keystone Components in your Rails application"

    TAILWIND_IMPORT = '@import "tailwindcss";'
    SOURCE_MARKER = "/* keystone:safelist */"

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
      changed = false

      # Inject or update @source inline safelist
      require_relative "../../keystone_components/safelist"
      source_line = "#{SOURCE_MARKER} @source inline(\"#{Keystone::SAFELIST}\");"
      if content.include?(SOURCE_MARKER)
        gsub_file css_path, /#{Regexp.escape(SOURCE_MARKER)}.*$/, source_line
        say "  ✔ Updated Tailwind safelist", :green
        changed = true
      else
        inject_into_file css_path, "#{source_line}\n", after: /#{Regexp.escape(TAILWIND_IMPORT)}\n/
        say "  ✔ Added Tailwind safelist", :green
        changed = true
      end

      say "  ✔ application.css already up to date", :green unless changed
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
