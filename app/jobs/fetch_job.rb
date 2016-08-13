class FetchJob < ApplicationJob
  queue_as :default

  def perform(context)
    is_initial = context.results.empty?
    context.fetch!
    if is_initial
      context.subscribers.each do &:notify
    end
  end
end
