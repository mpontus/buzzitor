class Monitoring::Result < ApplicationRecord
  belongs_to :context

  after_create_commit do
    serialized_context = MonitoringChannel.serialize_context context
    MonitoringChannel.broadcast_to context, serialized_context
  end
end
