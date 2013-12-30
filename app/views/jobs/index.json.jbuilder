json.array!(@jobs) do |job|
  json.extract! job, 
  json.url job_url(job, format: :json)
end
