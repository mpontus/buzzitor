require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Buzzitor
  class Application < Rails::Application
    config.generators do |g|
      g.javascript_engine :js
      g.test_framework    :rspec
    end
    config.autoload_paths << Rails.root.join('lib')
    # Enable any origin to connect to Action Cable
    config.action_cable.disable_request_forgery_protection = true
  end
end
