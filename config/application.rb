require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Climatologist
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    config.autoload_lib(ignore: %w[assets tasks])

    config.autoload_paths << "#{Rails.root}/lib"
  end
end
