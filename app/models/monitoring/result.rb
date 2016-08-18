class Monitoring::Result < ApplicationRecord
  belongs_to :context

  after_create_commit do
    # Broadcast new result via Action Cable
    serialized_context = MonitoringChannel.serialize_context context
    MonitoringChannel.broadcast_to context, serialized_context
  end

  after_create_commit do
    if context.results.length > 1 then
      # Compare old and new result
      old, new = context.results.last(2).map do |result|
        Nokogiri::HTML(result.content)
      end
      if old.to_xml != new.to_xml
        NotificationJob.perform(context)
      end
    end
  end
end
