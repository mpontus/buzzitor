class Monitoring::Result < ApplicationRecord
  belongs_to :context
  default_scope { order(:created_at) }
end
