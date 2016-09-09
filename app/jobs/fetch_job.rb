class FetchJob < ApplicationJob
  queue_as :default

  def perform(context)
    context.results << fetch(context.url)
    context.fetched_at = Time.now
    context.save!

    # Broadcast new result to all active visitors for this context
    serialized_context = MonitoringChannel.serialize_context context.reload
    MonitoringChannel.broadcast_to context, serialized_context

    if context.results.length == 1
      # Send welcoming notification after retrieving the initial result
      context.subscribers.all.each &:welcome
    else
      # Compare contents and erroneous status of this run with previous one
      old, new = context.results.last(2)
      if old.error_code != new.error_code or \
        not equivalent(old.content, new.content)
      then
        # Send the "page updated" message to all subscribers 
        context.subscribers.all.each &:update
      end
    end
  end

  private

  def fetch(url)
    begin
      Buzzitor::PageFetcher.fetch(url) do |driver|
        content = Buzzitor::PageProcessor.process(driver.html, url)
        screenshot = Base64.decode64(driver.render_base64)
        Monitoring::Result.new(
          title: driver.title,
          content: content,
          thumbnail: NamedStringIO.new("thumb.png", screenshot)
        );
      end
    rescue Capybara::Poltergeist::StatusFailError
      Monitoring::Result.new(
        error_code: Monitoring::ErrorCodes::CONNECTION_ERROR
      )
    rescue Capybara::Poltergeist::TimeoutError
      Monitoring::Result.new(
        error_code: Monitoring::ErrorCodes::TIMEOUT_ERROR
      )
    end
  end

  def equivalent(old, new)
    Buzzitor::PageComparator.compare(old, new)
  end

end
