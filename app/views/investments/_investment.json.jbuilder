json.extract! investment, :id, :name, :invested_amount, :status, :open_date, :end_date, :created_at, :updated_at
json.url investment_url(investment, format: :json)
