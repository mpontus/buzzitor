json.extract! @monitoring, :id, :url, :created_at, :updated_at
json.url monitoring_url(monitoring, format: :json)
