class NotificationJob < ApplicationJob
  queue_as :default

  def perform(context)
    context.subscribers.each &:notify
  end
end
