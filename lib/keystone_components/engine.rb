# frozen_string_literal: true

module KeystoneComponents
  class Engine < ::Rails::Engine
    config.autoload_paths << root.join("app/components")

    rake_tasks do
      namespace :keystone do
        desc "Inject @source path into application.css for Tailwind to scan component files"
        task inject_source: :environment do
          css_path = Rails.root.join("app/assets/tailwind/application.css")
          next unless css_path.exist?

          content = css_path.read
          marker = "/* keystone:source */"
          gem_path = KeystoneComponents::Engine.root
          source_line = "#{marker} @source \"#{gem_path}/app/components/**/*.{erb,rb}\";"

          if content.include?(marker)
            updated = content.sub(/#{Regexp.escape(marker)}.*$/, source_line)
            css_path.write(updated)
          end
        end
      end

      if Rake::Task.task_defined?("tailwindcss:build")
        Rake::Task["tailwindcss:build"].enhance(["keystone:inject_source"])
      end
    end
  end
end
