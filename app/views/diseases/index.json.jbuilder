json.array!(@diseases) do |disease|
  json.extract! disease, :id
  json.url disease_url(disease, format: :json)
end
