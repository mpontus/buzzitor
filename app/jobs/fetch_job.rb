class FetchJob < ApplicationJob
  queue_as :default

  def perform(context)
    context.results << fetch(context.url)
    context.save!

    serialized_context = MonitoringChannel.serialize_context context.reload
    MonitoringChannel.broadcast_to context, serialized_context

    if context.results.length == 1
      context.subscribers.all.each &:welcome
    else
      old, new = context.results.last(2)
      if old.error_code != new.error_code
        or not equivalent(old.content, new.content)
      then
        context.subscribers.all.each &:update
      end
    end
  end

  private

  def fetch(url)
    begin
      Buzzitor::Fetcher.fetch(url) do |driver|
        Monitoring::Result.new(
          content: cleanup(driver.html),
          screenshot: driver.render_base64
        );
      end
    rescue Capybara::Poltergeist::StatusFailError
      Monitoring::Result.new(
        error_code: Monitoring::ErrorCodes::SERVER_UNREACHABLE_ERROR
      )
    rescue Capybara::Poltergeist::TimeoutError
      Monitoring::Result.new(
        error_code: Monitoring::ErrorCodes::TIMEOUT_ERROR
      )
    end
  end

  # Removes script tags
  def cleanup(html)
    noko = Nokogiri::HTML(html)
    noko.xpath('//script').each(&:remove)
    noko.to_xhtml
  end

  # Compares two versions
  def equivalent(doc1, doc2)
    noko1 = Nokogiri::HTML(doc1)
    noko2 = Nokogiri::HTML(doc2)
    noko1.xpath('//body')[0].to_xhtml == noko2.xpath('//body')[0].to_xhtml
  end

end
