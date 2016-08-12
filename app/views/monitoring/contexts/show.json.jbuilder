json.extract! @monitoring_context, :id, :url, :created_at, :updated_at
if @monitoring_context.results.empty? then
  json.latest_content nil
else
  json.latest_content do
    json.status "content"
    json.url monitoring_result_url(@monitoring_context.results.last)
  end 
end
