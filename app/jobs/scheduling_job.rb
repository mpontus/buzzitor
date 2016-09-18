# This job is meant to be invoked at regular intervals. Ipolls outdated
# monitoring contexts and schedules FetchJob for them.

class SchedulingJob < ApplicationJob
  queue_as :default

  def perform
    # Monitoring Context is considered to be outdated if it was fetched more
    # than `interval` seconds ago.
    interval = APP_CONFIG['fetch_interval'] || 60
    Monitoring::Context
      .where(active: true)
      .where('fetched_at < :before',
             { before: interval.seconds.ago })
      .order(fetched_at: :asc).limit(1)
      .each do |context|
      FetchJob.perform_now(context)
    end
  end
end
