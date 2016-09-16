class Monitoring::Context < ApplicationRecord
  has_many :results
  has_many :subscribers

  validates :url, url: true

  after_create_commit do
    FetchJob.perform_later(self)
  end

  after_update_commit do
    # Broadcast new result to all active visitors for this context
    serialized_context = MonitoringChannel.serialize_context self.reload
    MonitoringChannel.broadcast_to self, serialized_context
  end

  def latest_result
    results.last
  end
end
