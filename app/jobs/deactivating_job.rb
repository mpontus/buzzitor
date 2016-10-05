class DeactivatingJob < ApplicationJob
  queue_as :default

  def perform
    # Monitoring Context is considered to be outdated if it was fetched more
    # than `interval` seconds ago.
    interval = APP_CONFIG['deactivation_interval'] || 3600
    query = Monitoring::Context
              .where(active: true)
              .where('visited_at <= :before',
                     { before: interval.seconds.ago })
    query.update_all(active: false)
  end
end
