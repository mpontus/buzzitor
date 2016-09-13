class MonitoringChannel < ApplicationCable::Channel
  class << self
    def serialize_context(context)
      Monitoring::ContextSerializer.new(context).as_json
    end
  end

  def subscribed
    context = Monitoring::Context.find(params[:id])
    stream_for context
    transmit MonitoringChannel.serialize_context(context)
  end
end
