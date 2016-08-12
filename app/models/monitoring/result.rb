module Monitoring
  class Result < ApplicationRecord
    belongs_to :context
  end
end
