class Monitoring::Context < ApplicationRecord
  has_many :results
  has_many :subscribers

  after_create_commit do
    FetchJob.perform_later(self)
  end
end
