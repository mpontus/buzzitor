json.extract! @context, :id, :url, :created_at, :updated_at
if @context.results.empty? then
  json.latest_content nil
else
  json.latest_content do
    json.status "content"
    json.url monitoring_result_url(@context.results.last)
  end 
end
