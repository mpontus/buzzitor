module Monitoring
  class Result < ApplicationRecord
    belongs_to :context

    after_create_commit do
      serialized_context = MonitoringChannel.serialize_context context.reload
      MonitoringChannel.broadcast_to context, serialized_context
    end

    after_create_commit do
      if context.results.length == 1 then
        context.subscribers.each &:notify_initial
      end
    end

    after_create_commit do
      if context.results.length > 1 then
        # Compare old and new result
        old, new = context.reload.results.last(2).map do |result|
          Nokogiri::HTML(result.content)
        end
        if old.to_xml != new.to_xml
          context.subscribers.each &:notify
        end
      end
    end
  end
end
