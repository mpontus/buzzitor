class Monitoring::Context < ApplicationRecord
  has_many :results
  has_many :subscribers

  validates :url, url: true

  after_create_commit do
    FetchJob.perform_later(self)
  end

  def latest_result
    results.last
  end
end
