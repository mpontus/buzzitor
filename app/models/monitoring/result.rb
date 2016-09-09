class Monitoring::Result < ApplicationRecord
  belongs_to :context
  default_scope { order(:created_at) }
  mount_uploader :thumbnail, ThumbnailUploader
end
