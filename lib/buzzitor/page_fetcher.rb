require 'capybara/poltergeist'

class Buzzitor::PageFetcher
  class << self
    def fetch(url)
      driver = Capybara::Poltergeist::Driver.new(
        nil,
        js_errors: false,
        phantomjs: Rails.root.join('bin', 'phantomjs').to_s,
        timeout: APP_CONFIG['page_fetcher_timeout'] || 0,
      )
      driver.visit(url)
      sleep APP_CONFIG['page_fetcher_delay'] || 0;
      yield driver
    # ensure
    #   driver.quit
    end
  end
end
