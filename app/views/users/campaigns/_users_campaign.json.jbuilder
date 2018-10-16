json.extract! users_campaign, :id, :name, :referal_token, :user_id, :created_at, :update_at
json.url users_campaign_url(users_campaign, format: :json)
