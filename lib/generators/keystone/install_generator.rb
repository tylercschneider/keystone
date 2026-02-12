# frozen_string_literal: true

module Keystone
  class InstallGenerator < Rails::Generators::Base
    desc "Set up Keystone UI in your Rails application"

    TAILWIND_IMPORT = '@import "tailwindcss";'
    SOURCE_MARKER = "/* keystone:source */"

    def setup_tailwind
      say ""
      say "Keystone UI — setup", :green
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

      # Remove legacy @import for engine CSS (no longer needed)
      legacy_import = '@import "../builds/tailwind/keystone_components_engine";' # also handles pre-rename installs
      if content.include?(legacy_import)
        gsub_file css_path, /#{Regexp.escape(legacy_import)}\n?/, ""
        say "  ✔ Removed legacy engine CSS import", :green
        changed = true
      end

      # Remove legacy inline safelist (replaced by @source path injection)
      legacy_safelist = "/* keystone:safelist */"
      if content.include?(legacy_safelist)
        gsub_file css_path, /#{Regexp.escape(legacy_safelist)}.*\n?/, ""
        say "  ✔ Removed legacy inline safelist", :green
        changed = true
      end

      # Inject marker comment (path is resolved at boot time by Railtie initializer)
      content = css_path.read # re-read after removals
      unless content.include?(SOURCE_MARKER)
        inject_into_file css_path, "#{SOURCE_MARKER}\n", after: /#{Regexp.escape(TAILWIND_IMPORT)}\n/
        say "  ✔ Added Keystone source marker", :green
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
