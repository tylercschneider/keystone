# frozen_string_literal: true

module KeystoneComponents
  class Engine < ::Rails::Engine
    config.autoload_paths << root.join("app/components")

    initializer "keystone_components.assets" do |app|
      app.config.assets.precompile += %w[
        keystone/themes/base.css
        keystone/themes/dark.css
      ]
    end
  end
end
