class Buzzitor::PageFetcher
  class << self
    def fetch(url)
      driver = Capybara::Poltergeist::Driver.new(
        nil,
        phantomjs: Phantomjs.path
      )
      driver.visit(url)
      sleep APP_CONFIG['fetcher_sleep'] || 0;
      yield driver
    ensure
      driver.quit
    end
  end
end
