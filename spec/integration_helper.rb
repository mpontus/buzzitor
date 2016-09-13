require 'rails_helper'
require 'capybara/rspec'
require 'capybara/poltergeist'

require 'puma'

Capybara.register_server(:puma) do |app, port, host|
  Rails.application.routes.default_url_options[:host] = "#{host}:#{port}"

  Puma::Server.new(app).tap do |s|
    s.add_tcp_listener(host, port)
  end.run.join
end

require 'phantomjs'

Capybara.register_driver :poltergeist_debug do |app|
  driver_options = {
    phantomjs: Phantomjs.path,
    inspector: true,
    timeout: 5,
    js_errors: false,
    debug: false,
    phantomjs_logger: Logger.new('/dev/null'),
    extensions: [
      File.expand_path("../../node_modules/promise-polyfill/promise.js", __FILE__),
      File.expand_path("../support/phantomjs_ext/push_manager.js", __FILE__)
    ]
  }
  if ENV['DEBUG_PHANTOMJS']
    driver_options.merge!({
      logger: Kernel,
      js_errors: true,
      debug: true,
      phantomjs_logger: File.open(Rails.root.join('log/phantomjs.log'), 'a')
    })
  end
  Capybara::Poltergeist::Driver.new(app, driver_options)
end

Capybara.register_driver :selenium_firefox do |app|
  Selenium::WebDriver::Firefox.path = Rails.root.to_s + '/firefox/firefox-bin'
  Capybara::Selenium::Driver.new(app, :browser => :firefox)
end

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  ActiveJob::Base.queue_adapter = :async
end

Capybara.server = :puma
Capybara.javascript_driver = :poltergeist_debug
