class MonitoringChannel < ApplicationCable::Channel
  class << self
    def serialize_context(context)
      def render(context)
        ApplicationController.renderer.render(context)
      end
      ActiveSupport::JSON.decode(render(context))
    end
  end

  def subscribed
    context = Monitoring::Context.find(params[:id])
    stream_for context
    transmit MonitoringChannel.serialize_context(context)
  end
end
