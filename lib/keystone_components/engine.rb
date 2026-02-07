# frozen_string_literal: true

module KeystoneComponents
  class Engine < ::Rails::Engine
    config.autoload_paths << root.join("app/components")
  end
end
