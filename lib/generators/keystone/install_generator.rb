# frozen_string_literal: true

require_relative "../../keystone_components/safelist"

module Keystone
  class InstallGenerator < Rails::Generators::Base
    desc "Set up Keystone Components in your Rails application"

    IMPORT_LINE = '@import "../builds/tailwind/keystone_components_engine";'
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

      # Inject @import for the engine CSS entry point
      unless content.include?(IMPORT_LINE)
        inject_into_file css_path, "#{IMPORT_LINE}\n", after: /@import\s+"tailwindcss";\n/
        say "  ✔ Added engine CSS import", :green
        changed = true
      end

      # Inject or update @source inline safelist
      source_line = "#{SOURCE_MARKER} @source inline(\"#{Keystone::SAFELIST}\");"
      if content.include?(SOURCE_MARKER)
        gsub_file css_path, /#{Regexp.escape(SOURCE_MARKER)}.*$/, source_line
        say "  ✔ Updated Tailwind safelist", :green
        changed = true
      else
        inject_into_file css_path, "#{source_line}\n", after: /#{Regexp.escape(IMPORT_LINE)}\n/
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
