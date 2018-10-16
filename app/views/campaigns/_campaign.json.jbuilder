json.extract! campaign, :id, :name, :affiliates_count, :earnings, :url, :created_at, :updated_at
json.url campaign_url(campaign, format: :json)
