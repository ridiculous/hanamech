json.array!(@parts) do |part|
  json.extract! part, 
  json.url part_url(part, format: :json)
end
