class FetchJob < ApplicationJob
  queue_as :default

  def perform(context)
    context.fetch!
  end
end
