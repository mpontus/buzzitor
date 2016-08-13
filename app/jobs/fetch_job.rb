class FetchJob < ApplicationJob
  queue_as :default

  def perform(monitoring)
    is_initial = monitoring.results.empty?
    monitoring.fetch!
    if is_initial
      monitoring.subscribers.each &:notify_initial
    end
  end
end
