class FetchJob < ApplicationJob
  queue_as :default

  def perform(page)
    page.fetch!
  end
end
