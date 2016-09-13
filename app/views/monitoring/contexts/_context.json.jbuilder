json.extract! context, :id, :created_at, :updated_at
if context.results.empty? then
  json.latest_result nil
else
  json.latest_result do
    result = context.results.last
    if !result.error_code
      json.status "content"
      json.url monitoring_result_path(result)
    else
      json.status "error"
      case result.error_code
      when Monitoring::ErrorCodes::TIMEOUT_ERROR
        json.message = "Timeout error"
      when Monitoring::ErrorCodes::CONNECTION_ERROR
        json.message = "Connection error"
      else
        json.message = "Unknown error"
      end
    end
  end
end
